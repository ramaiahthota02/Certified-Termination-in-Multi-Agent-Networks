# SUMMARY

Code and data for the paper

> H. R. Vidyashree, G. Thota, N. Vadlana, and R. Kumar, "Certified Termination in Multi-Agent
> Networks Under Denial-of-Service Attacks," IEEE Open Journal of Control Systems (under review).

The paper asks when a denial-of-service (DoS) attacker, limited by a duration budget and a frequency
budget, can stop a team of agents from ever confirming that every agent has finished its local task.
This package contains the simulator behind that study, the scripts that produce every table and
figure, and their output data.

- **Language and dependencies:** Python 3 (tested on 3.13) with numpy; matplotlib is needed only to
  redraw the figures. Nothing else.
- **Contents:** `code/` (11 scripts), `data/` (13 JSON files, one per experiment), `figures/` (the
  five figures of the paper, as vector PDFs), and `run_all.sh`, which regenerates all of it.
- **Runtime:** about 8 minutes in total on one core; no GPU and no network access are needed.
- **Reproducibility:** every random seed is fixed. Re-running a script overwrites its JSON file with
  byte-identical content, so the numbers in the paper can be traced to the data and back to the code
  that produced it.
- **License:** MIT (see `LICENSE`).

`README.md` maps every table and figure of the paper to the script and data file that produce it,
and documents the format of the data files.
