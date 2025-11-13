#!/bin/bash
# GWAS: PD+T2D vs PD-noT2D in OPDC / Discovery cohort
# Software: PLINK 2.0

set -euo pipefail

# ==== USER INPUTS: EDIT THESE PATHS ====

# Base PLINK2 binary prefix per chromosome:
# e.g. imputed_QC-r2-maf_chr01, imputed_QC-r2-maf_chr02, ...
BFILE_BASE="/gluster/dri02/rdscw/users/cynthias/CW017_PPMI/data/Steph_ODPC/plinkfiles/imputed_QC-r2-maf_chr"

PHENO_FILE="./pheno_PD+T2D_PD-T2D.txt"
PHENO_NAME="pheno"
COVAR_FILE="./covariates_opdc.txt"

OUT_PREFIX="OPDC_PD+T2D_PD-T2D_chr"

# ==== RUN GWAS PER CHROMOSOME ====

for chr in {1..22}; do
  CHR_FMT=$(printf "%02d" "${chr}")   # 01, 02, ..., 22
  BFILE="${BFILE_BASE}${CHR_FMT}"
  OUT="${OUT_PREFIX}${CHR_FMT}"

  echo "Running PLINK2 GWAS for OPDC, chromosome ${CHR_FMT}..."

  plink2 \
    --bfile "${BFILE}" \
    --pheno "${PHENO_FILE}" \
    --pheno-name "${PHENO_NAME}" \
    --glm \
    --covar "${COVAR_FILE}" \
    --covar-variance-standardize \
    --out "${OUT}"
done

echo "All OPDC chromosomes processed."

# ==== MERGE RESULTS ACROSS CHROMOSOMES ====

MERGED="OPDC_PD+T2D_PD-T2D_merged.pheno.glm.logistic.hybrid"

echo "Merging PLINK2 .glm results into ${MERGED} ..."

head -n 1 "${OUT_PREFIX}01".pheno.glm.logistic.hybrid > "${MERGED}"

for chr in {1..22}; do
  CHR_FMT=$(printf "%02d" "${chr}")
  FILE="${OUT_PREFIX}${CHR_FMT}.pheno.glm.logistic.hybrid"
  echo "Appending ${FILE}..."
  tail -n +2 "${FILE}" >> "${MERGED}"
done

echo "Merged OPDC results written to ${MERGED}"
