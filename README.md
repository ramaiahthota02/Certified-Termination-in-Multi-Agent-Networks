# Certified Termination in Multi-Agent Networks Under Denial-of-Service Attacks: code and data

Supplementary material for

> H. R. Vidyashree, G. Thota, N. Vadlana, and R. Kumar, "Certified Termination in Multi-Agent
> Networks Under Denial-of-Service Attacks," IEEE Open Journal of Control Systems (under review).

Every table and figure in the paper is produced by one of the scripts below from the data files in
`data/`, and every data file is produced by one of the scripts. All random seeds are fixed, so a
re-run reproduces each JSON file exactly.

## Contents

```
README.md             this file: how to run, what each script does, and the format of the data
SUMMARY.md            one-page overview
LICENSE               MIT
requirements.txt      Python dependencies
run_all.sh            regenerates every data file and figure from scratch
code/                 the simulator and the experiment scripts
data/                 one JSON file per experiment (the numbers behind the tables)
figures/              Fig. 1 to Fig. 5 as vector PDFs
```

## Requirements and how to run

Python 3.9 or later with numpy; matplotlib is needed only to redraw the figures. No GPU, no network
access and no other packages are required.

```bash
pip install -r requirements.txt
./run_all.sh              # regenerates data/*.json and figures/*.pdf
```

`run_all.sh` runs each script with `data/` as the working directory and `code/` on the Python path,
so the scripts can also be run one at a time:

```bash
cd data && PYTHONPATH=../code python3 ../code/e1_threshold.py
```

Total runtime is about 8 minutes on one core of a 2024-era laptop. Per script:

| Script | Runtime | Output |
|:--|--:|:--|
| `t1_sigma.py` | 10 s | `t1.json` |
| `e1_threshold.py` | 26 s | `e1.json` |
| `e4_grid.py` | 41 s | `e4.json` |
| `e2_duty.py` | 52 s | `e2.json` |
| `e2_periodic_check.py` | 1 s | console only |
| `e6_worstcase.py` | 55 s | `e6.json` |
| `e3_rwp.py` (four modes) | 3 min 14 s | `e3.json`, `e3_equal.json`, `e3_small.json`, `e5_n15/30/60.json` |
| `e7_formation.py` | 5 s | `e7.json` |
| `e8_connected_cover.py` | 22 s | `e8.json` |
| `figs.py` | 8 s | `figures/fig1..5.pdf` |

The longest step is the Random Waypoint sweep over n = 15, 30 and 60, which simulates mobility for
6000 rounds in each of 20 trials.

## What the code implements

`code/scgd_dos.py` is the simulator. It contains:

- the value layer and completion times (the Collatz update of S-CGD, which does not depend on the
  topology);
- token flooding (Definition 1), with the token sets as bitmasks, in both release rules: at
  completion (certificate flooding) and at start-up (precomputed flooding);
- the duration budget (κ, τ_D) of Definition 4 and the frequency budget (η, τ_F) of Definition 5,
  enforced online by the recursions of Section VI-A, which are equivalent to the definitions;
  only effective attack rounds (Definition 3) are charged;
- the intended schedules: the bridge path of Theorem 3, a round-robin path, and Random Waypoint
  mobility with unit-disk communication;
- the adversaries: bridge-blocking, periodic blackout with searched period and phase, random
  blackout, state-aware targeted blackout, its budget-saving variant, and the cut-covering
  adversary of Theorem 6;
- the bounds of Theorem 2 and Theorem 5, the characterization test of Theorem 4, and the
  coverability recursion of Definition 6 and Remark 9 (exact rational arithmetic);
- the two uncertified baselines, max-consensus and linear consensus, replayed on the same attacked
  edge sequence.

## Map from the paper to the code and data

| Paper item | Script | Data file |
|:--|:--|:--|
| Table I (Collatz stopping times) | `t1_sigma.py` | `t1.json` |
| Table II (frequency threshold on the path) | `e1_threshold.py` | `e1.json` |
| Table III and Fig. 5 (duty-cycle threshold) | `e2_duty.py` | `e2.json` |
| Table III, the ∞ entries | `e2_periodic_check.py` | console output |
| Table IV (exact worst case, small paths) | `e6_worstcase.py` | `e6.json` |
| Table V (Random Waypoint, n = 30) | `e3_rwp.py` | `e3.json` |
| Table VI (overhead by setting) | `e3_rwp.py` in modes `equal`, `small`, `nsweep` | `e3_equal.json`, `e3_small.json`, `e5_n15/30/60.json` |
| Table VII (dissemination times) | same as Table VI | same as Table VI |
| Table VIII (formation assembly) | `e7_formation.py` | `e7.json` |
| Section VI-E, instance-level check | `e3_rwp.py` (singleton cuts), `e8_connected_cover.py` (all cuts) | `e3.json` field `cov`, `e8.json` |
| Fig. 1 to Fig. 5 | `figs.py` | `e2.json`, `e4.json`, rest simulated inline |
| Fig. 4 (540-point grid) | `e4_grid.py` | `e4.json` |

## Format of the data files

All files are JSON. Quartile fields written `[q1, median, q3, max]` use the sixth and 16th order
statistics of 20 trials as q1 and q3, the convention stated in Section VI-A. Times are in rounds,
and `null` means the run did not certify within the horizon.

**`t1.json`** (Table I). A list of six rows: `M`, `m_star` (a maximizer), `Sigma` (the largest total
stopping time at most `M`), and the two normalized columns `ratio_log` and `ratio_log2`.

**`e1.json`** (Table II). A list of 21 rows, one per (L, τ_F) pair:
`L`, `kappa`, `tau_D`, `tau_F`, `pred` (`"diverge"` or `"converge"`, the prediction of Theorem 4),
`conv` (trials that certified, out of `trials`), `med`, `q1`, `q3`, `maxT` (the certification time
T_sync), `bound_min` (the bound of Theorem 2(b)), `max_ratio` (bound over the worst trial),
`max_cross` (messages that crossed the bridge, 0 confirms that the attack isolated the two sides).

**`e2.json`** (Table III, Fig. 5). A list of 10 rows, one per τ_D. Each has `tau_D`, `bound_min`,
`bound_max` (the bound σ* + D_a), and one block per adversary (`bridge`, `periodic`, `random`,
`none`) holding `conv`, `med`, `q1`, `q3`, `maxT`.

**`e4.json`** (Fig. 4). A list of 540 rows, one per grid point: `kappa`, `tau_D`, `tau_F`, `L`,
`ell` (the burst length used by the adversary), `pred` (true if Theorem 4 guarantees certification),
`conv` out of `trials`, `ok` (true when the outcome matches `pred`), and `max_cross_nonconv`.

**`e6.json`** (Table IV). A list of 180 rows, one per parameter point on P_4 and P_5: `n`, `W`,
`kappa`, `tau_D`, `tau_F`, `guaranteed` (Theorem 4), `worst` (the exact worst-case dissemination
time over all admissible attacks, `null` if some attack blocks forever), `bound` (the smallest
applicable bound of Theorem 2), `agree_thm4`, `instance_blockable` (some cut coverable, Theorem 6),
and `agree_thm6`.

**`e3.json`, `e3_equal.json`, `e3_small.json`, `e5_n15.json`, `e5_n30.json`, `e5_n60.json`**
(Tables V to VII). Each has three keys:

- `rows`: one row per (scenario, method, adversary). Fields: `scenario` (`none`, `B`, `D`, `H`),
  `method`, `adversary`, `conv` out of `trials`, `T_q` (completion time), `inc_q` (increase over the
  attack-free run of the same trial), `frac_med` (median fraction of attacked rounds before
  completion), `bound_med` and `bound_holds` (the applicable bound and whether it held in every
  trial), `overhead_q` (T_sync − σ*, certificate flooding), `diss_q` and `diss_done` (dissemination
  time P, precomputed flooding), and the diagnostics at σ*: `probe_g_med` (budget level),
  `probe_burst_med` (length of the first burst after σ*), `probe_incomplete_med` (tokens not yet
  everywhere).
- `info`: one entry per trial, describing the realized schedule: `W`, `frac` (fraction of connected
  rounds), `rho`, `beta`, `sig` (σ*), `tauD_D`, `min_single_density` (the smallest crossing density
  of a singleton cut), and `cov`, the singleton-coverability counts per scenario from round 0 and
  from round σ_i (0 everywhere, so no robot can be isolated).
- `summary`: quartiles of those per-trial quantities.

**`e7.json`** (Table VIII). `rows`, one per (budget, adversary): `scenario`, `adversary`, `conv`,
`trials`, `overhead_q` (T_sync − c*), `frac_med`, `bound` (Corollary 5), `bound_holds`. Also
`cstar`, the quartiles of the last arrival time.

**`e8.json`** (Section VI-E). `t0`, the tested start rounds; `rows`, one per trial, giving `frac`
and, for scenarios `D` and `H`, a boolean per start round saying whether the set of rounds with a
connected intended graph is coverable (all false); and `last_long_run_start`, the start of the last
run of more than L consecutive connected rounds in each trial.

## Verification performed

The whole package was regenerated from scratch with `run_all.sh` in a clean directory, on Python
3.13.18 with numpy 2.5.3 and matplotlib 3.11.2, in 7 minutes. Every one of the 13 data files came
back identical to the file shipped here, compared field by field after JSON parsing. The five
figures came back with the same content; their PDFs are not byte-identical across matplotlib
versions, because the tight bounding box shifts by a fraction of a point.

## License

MIT, see `LICENSE`. If you use this code, please cite the paper above.
