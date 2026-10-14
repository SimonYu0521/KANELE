"""
Evaluate a raw-window model (B2 or B3) against the parsed-encoding model on IDENTICAL events.

  python eval_b2.py <window_model_dir> [--enc=b2|b3] [--smoke]      (default --enc=b2)

Operating points (pre-filter convention: forward iff score >= tau, drop otherwise):
  * tau = floor : drop only the model's minimum-score point mass (score <= floor*1.0001).
                  This is the LOWEST achievable FN while still filtering anything.
  * tau = 0.5 (argmax), tau tuned on val (from final_test_report.json), and a few fixed taus.
Sets:
  * TEST  = X_test[400000:] (touched-once test; same rows in data_us and data_us_b2)
  * FULL  = all 191,853,274 events (includes the 80% of malicious used in training -> optimistic)
Writes <ENC>_RESULTS.json + <ENC>_RESULTS.md next to this script.
"""
import os, sys, json, gzip, time
import numpy as np, torch, torch.nn as nn
from sklearn.metrics import roc_auc_score, average_precision_score

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(HERE, "../../src"))
from KANQuant import KANQuant
from quant import QuantBrevitasActivation, ScalarBiasScale
from brevitas.nn import QuantHardTanh
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType
from build_dataset import SAFE, UNSAFE
torch.set_num_threads(os.cpu_count())

B2_DIR = os.path.abspath(sys.argv[1])
SMOKE = "--smoke" in sys.argv            # tiny slices, to exercise the code path quickly
ENC = next((a.split("=", 1)[1] for a in sys.argv if a.startswith("--enc=")), "b2")
LBL = ENC.upper()
DATA_DIR = f"data_us_{ENC}"
def WIN(raw):                            # raw line bytes -> 64-byte window encoding
    if ENC == "b2": return raw[51:59].ljust(8, b"\0") + raw[258:314].ljust(56, b"\0")
    x = 254 + (raw.index(b'"', 51) - 51)   # b3: floating slice-2 start = exe value start
    return raw[51:59].ljust(8, b"\0") + raw[x:x + 56].ljust(56, b"\0")
P0_DIR = os.path.join(HERE, "models/20260709_193605_undersample")
N_VAL = 400_000
TAUS = [0.5, 0.1, 0.01, 0.001]
SLOTS = [("syscall", 8), ("object_type", 4), ("exe", 16), ("path", 36)]


def load_model(d):
    cfg = json.load(open(f"{d}/config.json"))
    bn = nn.BatchNorm1d(cfg["layers"][0]); nn.init.constant_(bn.weight.data, 1); nn.init.constant_(bn.bias.data, 0)
    il = QuantBrevitasActivation(QuantHardTanh(bit_width=cfg["layers_bitwidth"][0], max_val=1.0, min_val=-1.0,
         act_scaling_impl=ParameterScaling(1.33), quant_type=QuantType.INT, return_quant_tensor=False),
         pre_transforms=[bn, ScalarBiasScale(scale=False, bias_init=-0.25)], cuda=False)
    m = KANQuant(cfg, il, torch.device("cpu"))
    m.load_state_dict(torch.load(f"{d}/NID_best.pt", map_location="cpu", weights_only=False)["model_state_dict"])
    return m.eval()


def score(model, U):                       # U uint8 [M,64] unique patterns
    out = np.empty(len(U), np.float64)
    with torch.no_grad():
        for i in range(0, len(U), 65536):
            out[i:i + 65536] = torch.softmax(model(torch.from_numpy(U[i:i + 65536].astype(np.float32))), 1)[:, 1].double().numpy()
    return out


def ops(su, nb, nm):
    """su: score per unique pattern; nb/nm: benign/malicious counts per pattern."""
    floor = su.min(); tot = nb.sum() + nm.sum(); M = nm.sum()
    def at(mask_fwd, name, tau):
        fn = int(nm[~mask_fwd].sum()); fp = int(nb[mask_fwd].sum())
        return dict(op=name, tau=float(tau), FN=fn, FNR=fn / M, FP=fp, forwarded_pct=100 * (nb[mask_fwd].sum() + nm[mask_fwd].sum()) / tot)
    r = [at(su > floor * 1.0001, "floor", floor)]
    r += [at(su >= t, f"tau={t:g}", t) for t in TAUS]
    return floor, r


def unique_counts(X, y):
    v = np.ascontiguousarray(X).view(np.dtype((np.void, 64))).ravel()
    u, inv = np.unique(v, return_inverse=True)
    inv = inv.ravel()
    nb = np.bincount(inv[y == 0], minlength=len(u)).astype(np.int64)
    nm = np.bincount(inv[y == 1], minlength=len(u)).astype(np.int64)
    return u.view(np.uint8).reshape(-1, 64), inv, nb, nm


def eval_test(model, data_dir, tuned_tau):
    end = N_VAL + 200_000 if SMOKE else None
    X = np.load(f"{HERE}/{data_dir}/X_test.npy", mmap_mode="r")[N_VAL:end]
    y = np.load(f"{HERE}/{data_dir}/y_test.npy")[N_VAL:end]
    U, inv, nb, nm = unique_counts(X, y)
    su = score(model, U)
    floor, rows = ops(su, nb, nm)
    if tuned_tau is not None:
        m = su >= tuned_tau
        rows.append(dict(op="tuned", tau=tuned_tau, FN=int(nm[~m].sum()), FNR=nm[~m].sum() / nm.sum(),
                         FP=int(nb[m].sum()), forwarded_pct=100 * (nb[m].sum() + nm[m].sum()) / (nb.sum() + nm.sum())))
    s = su[inv]
    return dict(n=int(len(y)), mal=int(y.sum()), unique=int(len(U)), floor=float(floor),
                roc_auc=float(roc_auc_score(y, s)), pr_auc=float(average_precision_score(y, s)), ops=rows)


def eval_full(m_p0, m_b2):
    """Stream all 191.9M raw lines once; count per-pattern (benign, malicious) for both encodings."""
    cnt = {"p0": {}, "b2": {}}
    t0 = time.time()
    for path, lab in ((UNSAFE, 1), (SAFE, 0)):
        with gzip.open(path, "rb") as f:
            for i, line in enumerate(f):
                if SMOKE and i >= 300_000: break
                raw = line.rstrip(b"\n")
                r = json.loads(raw)
                kp = b"".join(str(r.get(fl) or "").encode("ascii", "ignore")[:w].ljust(w, b"\0") for fl, w in SLOTS)
                kb = WIN(raw)
                for d, k in ((cnt["p0"], kp), (cnt["b2"], kb)):
                    c = d.get(k)
                    if c is None: d[k] = c = [0, 0]
                    c[lab] += 1
                if i % 20_000_000 == 0 and i:
                    print(f"  full: {path.split('.')[-3]} {i:,} lines ({time.time()-t0:.0f}s)", flush=True)
    out = {}
    for name, model in (("p0", m_p0), ("b2", m_b2)):
        keys = list(cnt[name].keys())
        U = np.frombuffer(b"".join(keys), np.uint8).reshape(-1, 64)
        c = np.array([cnt[name][k] for k in keys], np.int64)
        su = score(model, U)
        floor, rows = ops(su, c[:, 0], c[:, 1])
        out[name] = dict(n=int(c.sum()), mal=int(c[:, 1].sum()), unique=len(keys), floor=float(floor), ops=rows)
    return out


def check_fast_pack(n=200_000):
    """the full-dataset pass uses a bytes re-implementation of build_dataset.pack -> must be identical"""
    from build_dataset import pack
    with gzip.open(UNSAFE, "rb") as f:
        for i, line in enumerate(f):
            if i >= n: break
            r = json.loads(line)
            kp = b"".join(str(r.get(fl) or "").encode("ascii", "ignore")[:w].ljust(w, b"\0") for fl, w in SLOTS)
            assert kp == bytes(pack(r)), f"fast pack mismatch at line {i}"
    print(f"fast pack == build_dataset.pack on {n:,} lines", flush=True)


def main():
    t0 = time.time()
    check_fast_pack()
    m_b2, m_p0 = load_model(B2_DIR), load_model(P0_DIR)
    tuned = {}
    for k, d in (("b2", B2_DIR), ("p0", P0_DIR)):
        rep = f"{d}/final_test_report.json"
        tuned[k] = json.load(open(rep))["at_tuned"]["threshold"] if os.path.exists(rep) else None
    res = {"b2_model": B2_DIR, "p0_model": P0_DIR, "test": {}, "full": None}
    res["enc"] = ENC
    res["test"]["b2"] = eval_test(m_b2, DATA_DIR, tuned["b2"]); print(f"test {ENC} done", flush=True)
    res["test"]["p0"] = eval_test(m_p0, "data_us", tuned["p0"]);    print("test p0 done", flush=True)
    OUTP = f"{HERE}/{LBL}_RESULTS{'_SMOKE' if SMOKE else ''}"
    json.dump(res, open(f"{OUTP}.json", "w"), indent=2, default=float)
    res["full"] = eval_full(m_p0, m_b2); print("full done", flush=True)
    json.dump(res, open(f"{OUTP}.json", "w"), indent=2, default=float)

    L = [f"# {LBL} raw-window encoding vs parsed encoding — false negatives", "",
         f"- {LBL} model: `{os.path.relpath(B2_DIR, HERE)}`  |  parsed model: `{os.path.relpath(P0_DIR, HERE)}`",
         f"- Same events, same split; only the 64-byte encoding differs (see build_{ENC}.py).",
         "- `floor` = drop only the minimum-score point mass -> lowest achievable FN while still filtering.", ""]
    for setname, title in (("test", "TEST (touched-once, 37.97M events)"), ("full", "FULL dataset (191.9M; includes training malicious -> optimistic)")):
        L += [f"## {title}", "", "| encoding | op | tau | FN | FNR | FP | forwarded % |", "|---|---|--:|--:|--:|--:|--:|"]
        for enc in ("p0", "b2"):
            R = res[setname][enc]
            for o in R["ops"]:
                L.append(f"| {'parsed' if enc == 'p0' else LBL} | {o['op']} | {o['tau']:.3g} | {o['FN']:,} | {100*o['FNR']:.4f}% | {o['FP']:,} | {o['forwarded_pct']:.2f} |")
        extra = "  ".join(f"{'parsed' if e=='p0' else LBL}: unique {res[setname][e]['unique']:,}, floor {res[setname][e]['floor']:.3e}"
                          + (f", ROC-AUC {res[setname][e]['roc_auc']:.4f}, PR-AUC {res[setname][e]['pr_auc']:.4f}" if setname == "test" else "")
                          for e in ("p0", "b2"))
        L += ["", extra, ""]
    open(f"{OUTP}.md", "w").write("\n".join(L) + "\n")
    print(f"EVALDONE ({time.time()-t0:.0f}s)", flush=True)


if __name__ == "__main__":
    main()
