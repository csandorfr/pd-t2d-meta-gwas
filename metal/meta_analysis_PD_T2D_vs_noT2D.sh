#!/bin/bash
# Run METAL meta-analysis for PD+T2D vs PD-noT2D
# Software: METAL

set -euo pipefail

# ==== USER INPUTS: EDIT IF NEEDED ====
METAL_SCRIPT="./metal/meta_PD_T2D_vs_noT2D.txt"

echo "Running METAL with script: ${METAL_SCRIPT}"

metal "${METAL_SCRIPT}"

echo "Meta-analysis complete. Check META_PD_T2D_vs_noT2D*.tbl outputs."
