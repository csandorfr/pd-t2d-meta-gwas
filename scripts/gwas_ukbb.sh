#!/bin/bash
# GWAS: PD+T2D vs PD-noT2D in UK Biobank
# Software: PLINK 2.0

set -euo pipefail

# ==== USER INPUTS: EDIT THESE PATHS ====

# Base PLINK2 binary prefix (one file per chromosome, e.g. ukb22828_plink_chr1, chr2, ...)
BFILE_BASE="/nfs/dri/02/rdscw/shared/public/UKBIOBANK/genetics/ukb2282_plink_files/ukb22828_plink_chr"

# Phenotype and covariate files
PHENO_FILE="./pheno_PD+T2D_PD-T2D.txt"
PHENO_NAME="pheno"
COVAR_FILE="./covariates_ukbb.txt"

# Output prefix for per-chromosome files
OUT_PREFIX="UKBB_PD+T2D_PD-T2D_chr"

# ==== RUN GWAS PER CHROMOSOME ====

for chr in {1..22}; do
  BFILE="${BFILE_BASE}${chr}"
  OUT="${OUT_PREFIX}${chr}"

  echo "Running PLINK2 GWAS for UKBB, chromosome ${chr}..."

  plink2 \
    --bfile "${BFILE}" \
    --pheno "${PHENO_FILE}" \
    --pheno-name "${PHENO_NAME}" \
    --glm \
    --covar "${COVAR_FILE}" \
    --covar-variance-standardize \
    --out "${OUT}"
done

echo "All chromosomes processed."

# ==== MERGE RESULTS ACROSS CHROMOSOMES ====

MERGED="UKBB_PD+T2D_PD-T2D_merged.pheno.glm.logistic.hybrid"

echo "Merging PLINK2 .glm results into ${MERGED} ..."

# Use chr1 for the header
head -n 1 "${OUT_PREFIX}1".pheno.glm.logistic.hybrid > "${MERGED}"

# Append remaining
for chr in {1..22}; do
  FILE="${OUT_PREFIX}${chr}.pheno.glm.logistic.hybrid"
  echo "Appending ${FILE}..."
  tail -n +2 "${FILE}" >> "${MERGED}"
done

echo "Merged UKBB results written to ${MERGED}"
