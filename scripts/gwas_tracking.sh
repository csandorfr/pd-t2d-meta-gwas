#!/bin/bash
# GWAS: PD+T2D vs PD-noT2D in Tracking Parkinson's cohort
# Software: PLINK 2.0

set -euo pipefail

# ==== USER INPUTS: EDIT THESE PATHS ====

# Single PLINK2 binary prefix for Tracking
BFILE="/scratch/c.mpmcs1/CW050_T2D_CALEB/Tracking/PD_PROBAND_All_Chrs_0.8_INFO_maf_0.001_geno_0.01_hwe_0.00001_RS_QC"

PHENO_FILE="./pheno_PD+T2D_PD-T2D.txt"
PHENO_NAME="pheno"
COVAR_FILE="./reformatted_covariates.txt"

OUT_PREFIX="Tracking_PD+T2D_PD-T2D"

# ==== RUN GWAS ====

echo "Running PLINK2 GWAS for Tracking cohort..."

plink2 \
  --bfile "${BFILE}" \
  --pheno "${PHENO_FILE}" \
  --pheno-name "${PHENO_NAME}" \
  --glm \
  --covar "${COVAR_FILE}" \
  --covar-variance-standardize \
  --out "${OUT_PREFIX}"

echo "Tracking GWAS finished. Output prefix: ${OUT_PREFIX}"
