# B3 raw-window encoding vs parsed encoding — false negatives

- B3 model: `models/20261013_145858_undersample_b3`  |  parsed model: `models/20260709_193605_undersample`
- Same events, same split; only the 64-byte encoding differs (see build_b3.py).
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
| B3 | floor | 7.09e-05 | 44 | 0.0152% | 887,484 | 3.10 |
| B3 | tau=0.5 | 0.5 | 108 | 0.0372% | 6,715 | 0.78 |
| B3 | tau=0.1 | 0.1 | 60 | 0.0207% | 12,927 | 0.80 |
| B3 | tau=0.01 | 0.01 | 52 | 0.0179% | 32,103 | 0.85 |
| B3 | tau=0.001 | 0.001 | 49 | 0.0169% | 108,751 | 1.05 |
| B3 | tuned | 0.978 | 412 | 0.1420% | 311 | 0.76 |

parsed: unique 624,643, floor 7.381e-05, ROC-AUC 0.9999, PR-AUC 0.9996  B3: unique 650,984, floor 7.088e-05, ROC-AUC 0.9999, PR-AUC 0.9998

## FULL dataset (191.9M; includes training malicious -> optimistic)

| encoding | op | tau | FN | FNR | FP | forwarded % |
|---|---|--:|--:|--:|--:|--:|
| parsed | floor | 7.38e-05 | 195 | 0.0133% | 6,701,914 | 4.26 |
| parsed | tau=0.5 | 0.5 | 715 | 0.0488% | 189,310 | 0.86 |
| parsed | tau=0.1 | 0.1 | 340 | 0.0232% | 422,752 | 0.98 |
| parsed | tau=0.01 | 0.01 | 213 | 0.0145% | 858,670 | 1.21 |
| parsed | tau=0.001 | 0.001 | 210 | 0.0143% | 1,816,158 | 1.71 |
| B3 | floor | 7.09e-05 | 195 | 0.0133% | 4,831,440 | 3.28 |
| B3 | tau=0.5 | 0.5 | 458 | 0.0312% | 37,821 | 0.78 |
| B3 | tau=0.1 | 0.1 | 249 | 0.0170% | 76,521 | 0.80 |
| B3 | tau=0.01 | 0.01 | 217 | 0.0148% | 187,089 | 0.86 |
| B3 | tau=0.001 | 0.001 | 208 | 0.0142% | 601,320 | 1.08 |

parsed: unique 2,586,552, floor 7.381e-05  B3: unique 2,621,453, floor 7.088e-05

