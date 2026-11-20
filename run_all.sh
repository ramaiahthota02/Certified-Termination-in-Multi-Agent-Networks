#!/usr/bin/env bash
# Regenerates every data file and figure of
#   "Certified Termination in Multi-Agent Networks Under Denial-of-Service Attacks".
# Usage:  ./run_all.sh          (about 8 minutes on one core)
# Scripts run with data/ as the working directory, so each one overwrites its own JSON file there.
set -euo pipefail
cd "$(dirname "$0")"
ROOT="$PWD"
export PYTHONPATH="$ROOT/code"
export FIG_OUT="$ROOT/figures/"
mkdir -p data figures
cd data

run () {           # run <script> <description> [args...]
  local script=$1 desc=$2; shift 2
  printf '%-28s %s\n' "$script" "$desc"
  local t0=$SECONDS
  python3 "$ROOT/code/$script" "$@" > "$ROOT/$script.log" 2>&1
  printf '%-28s done in %d s\n' "" $((SECONDS - t0))
}

run t1_sigma.py            "Table I: maximal Collatz total stopping times"
run e1_threshold.py        "Table II: frequency threshold on the path"
run e4_grid.py             "Fig. 4: 540-point grid of Theorem 4"
run e2_duty.py             "Table III and Fig. 5: duty-cycle threshold"
run e2_periodic_check.py   "Table III: exact certificate that the periodic attack never lets certification finish"
run e6_worstcase.py        "Table IV: exact worst case over all attacks on small paths"
run e3_rwp.py              "Table V: Random Waypoint networks, n = 30"
run e3_rwp.py              "Table VI: all robots start at 327" equal
run e3_rwp.py              "Tables VI and VII: small completion times" small
run e3_rwp.py              "Tables VI and VII: n = 15, 30, 60" nsweep
run e7_formation.py        "Table VIII: formation assembly"
run e8_connected_cover.py  "Section VI-E: cut-independent coverability check"
run figs.py                "Fig. 1 to Fig. 5"

echo
echo "Data files are in data/, figures in figures/, per-script console output in *.log."
