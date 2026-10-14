# B2 raw-window encoding vs parsed encoding — false negatives

- B2 model: `models/20261007_152104_undersample_b2`  |  parsed model: `models/20260709_193605_undersample`
- Same events, same split; only the 64-byte encoding differs (see build_b2.py).
- `floor` = drop only the minimum-score point mass -> lowest achievable FN while still filtering.

## TEST (touched-once, 37.97M events)

| encoding | op | tau | FN | FNR | FP | forwarded % |
|---|---|--:|--:|--:|--:|--:|
| parsed | floor | 7.38e-05 | 42 | 0.0145% | 1,300,060 | 4.19 |
| parsed | tau=0.5 | 0.5 | 140 | 0.0483% | 37,016 | 0.86 |
| parsed | tau=0.1 | 0.1 | 78 | 0.0269% | 78,334 | 0.97 |
| parsed | tau=0.01 | 0.01 | 46 | 0.0159% | 158,125 | 1.18 |
| parsed | tau=0.001 | 0.001 | 46 | 0.0159% | 342,232 | 1.67 |
| parsed | tuned | 0.996 | 1,266 | 0.4363% | 938 | 0.76 |
| B2 | floor | 6.98e-05 | 46 | 0.0159% | 3,189,142 | 9.16 |
| B2 | tau=0.5 | 0.5 | 82 | 0.0283% | 18,196 | 0.81 |
| B2 | tau=0.1 | 0.1 | 63 | 0.0217% | 31,572 | 0.85 |
| B2 | tau=0.01 | 0.01 | 56 | 0.0193% | 70,843 | 0.95 |
| B2 | tau=0.001 | 0.001 | 53 | 0.0183% | 196,524 | 1.28 |
| B2 | tuned | 0.996 | 796 | 0.2743% | 248 | 0.76 |

parsed: unique 624,643, floor 7.381e-05, ROC-AUC 0.9999, PR-AUC 0.9996  B2: unique 650,972, floor 6.978e-05, ROC-AUC 0.9999, PR-AUC 0.9995

## FULL dataset (191.9M; includes training malicious -> optimistic)

| encoding | op | tau | FN | FNR | FP | forwarded % |
|---|---|--:|--:|--:|--:|--:|
| parsed | floor | 7.38e-05 | 195 | 0.0133% | 6,701,914 | 4.26 |
| parsed | tau=0.5 | 0.5 | 715 | 0.0488% | 189,310 | 0.86 |
| parsed | tau=0.1 | 0.1 | 340 | 0.0232% | 422,752 | 0.98 |
| parsed | tau=0.01 | 0.01 | 213 | 0.0145% | 858,670 | 1.21 |
| parsed | tau=0.001 | 0.001 | 210 | 0.0143% | 1,816,158 | 1.71 |
| B2 | floor | 6.98e-05 | 198 | 0.0135% | 16,594,707 | 9.41 |
| B2 | tau=0.5 | 0.5 | 366 | 0.0250% | 98,320 | 0.82 |
| B2 | tau=0.1 | 0.1 | 277 | 0.0189% | 176,194 | 0.86 |
| B2 | tau=0.01 | 0.01 | 243 | 0.0166% | 394,555 | 0.97 |
| B2 | tau=0.001 | 0.001 | 235 | 0.0160% | 1,064,426 | 1.32 |

parsed: unique 2,586,552, floor 7.381e-05  B2: unique 2,621,439, floor 6.978e-05

