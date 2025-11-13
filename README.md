# Meta-GWAS: Parkinson’s Disease With vs Without Type 2 Diabetes  
**Repository:** `pd-t2d-meta-gwas`  
**Analyses:** UK Biobank · Tracking Parkinson’s · OPDC (Discovery Cohort)

---

## Overview

This repository contains all scripts used to perform a meta-analysis of genome-wide
association studies (GWAS) comparing:

- **Parkinson’s disease patients with a history of type 2 diabetes (PD+T2D)**  
  versus  
- **Parkinson’s disease patients without a history of type 2 diabetes (PD-noT2D)**

across three independent population cohorts:

1. **Oxford Parkinson's Disease Discovery Cohort (OPDC)**
2. **Tracking Parkinson’s**
3. **UK Biobank (UKBB)**

The analyses include:

- Cohort-specific GWAS using **PLINK 2.0** (`--glm`)
- Covariate adjustment (age, sex, ancestry PCs)
- Chromosome-wise analysis and merging
- Harmonisation of summary statistics
- Fixed-effect inverse-variance meta-analysis using **METAL**

---

## Repository Structure

```
pd-t2d-meta-gwas/
│
├── README.md
│
├── scripts/
│   ├── gwas_ukbb.sh
│   ├── gwas_tracking.sh
│   ├── gwas_opdc.sh
│   ├── meta_analysis_PD_T2D_vs_noT2D.sh
│
├── metal/
  └── meta_PD_T2D_vs_noT2D.txt

```

---

## Cohorts

### **1. OPDC / Discovery Cohort**
- **N = 965 PD** participants  
- **69 with T2D**  
- Imputation & QC described in: *see main manuscript and ref. 88.*

### **2. Tracking Parkinson’s**
- **N = 1,436 PD** participants  
- **97 with T2D**  
- Imputation/QC identical to OPDC.

### **3. UK Biobank (UKBB)**
- **N = 5,460** participants with Parkinson's disease (diagnosed by 2023)  
- **866 with T2D**  
- T2D phenotype defined using **UKBB Field 22009**  
  https://biobank.ndph.ox.ac.uk/ukb/field.cgi?id=22009

---

## Phenotype Definition

Each cohort uses a binary phenotype file:

| Column | Description |
|--------|-------------|
| `FID` | Family ID |
| `IID` | Individual ID |
| `pheno` | 1 = PD-noT2D, 2 = PD+T2D |

---

## Covariates

Each GWAS includes adjustment for:

- **Sex**
- **Age**
- **PC1 & PC2** (ancestry)
- Additional PCs as available

Covariate files must contain matching FID/IID.

---

## Methods Summary

### **GWAS**
Each cohort was analysed with *PLINK 2.0 (`--glm`)* using logistic regression:

```
plink2 --bfile <data>        --pheno pheno_file        --pheno-name pheno        --glm        --covar covariates.txt        --covar-variance-standardize        --out results_prefix
```

### **Chromosome-wise UKBB + OPDC**
UKBB and OPDC genotypes are split by chromosome.  
Per-chromosome results are merged automatically by the scripts.

### **Harmonisation for Meta-analysis**
For each cohort we generate a file with at least:

- `ID` (rsID)
- `A1` (effect allele)
- `BETA`
- `SE`
- `P`

### **Meta-analysis (METAL)**
Fixed-effect inverse-variance method:

```
SCHEME STDERR
PROCESS OPDC_mapped.txt
PROCESS UKBB_mapped.txt
PROCESS Tracking_mapped.txt
ANALYZE
```

---

## How to Run the Analyses

### **1. UK Biobank GWAS**

```bash
bash scripts/gwas_ukbb.sh
```

Output will include:

```
UKBB_PD+T2D_PD-T2D_chr*.pheno.glm.logistic.hybrid
UKBB_PD+T2D_PD-T2D_merged.pheno.glm.logistic.hybrid
```

---

### **2. Tracking Parkinson’s GWAS**

```bash
bash scripts/gwas_tracking.sh
```

Produces:

```
Tracking_PD+T2D_PD-T2D.pheno.glm.logistic.hybrid
```

---

### **3. OPDC GWAS**

```bash
bash scripts/gwas_opdc.sh
```

Produces:

```
OPDC_PD+T2D_PD-T2D_chr*.pheno.glm.logistic.hybrid
OPDC_PD+T2D_PD-T2D_merged.pheno.glm.logistic.hybrid
```

---

### **4. Meta-analysis**

Ensure these mapped files exist:

```
OPDC_mapped.txt
UKBB_2025_mapped.txt
Tracking_mapped.txt
```

Then run METAL:

```bash
bash scripts/meta_analysis_PD_T2D_vs_noT2D.sh
```

Outputs:

```
META_PD_T2D_vs_noT2D1.tbl
META_PD_T2D_vs_noT2D1.tbl.info
```

---

## Software Versions

Please record your exact versions in this section  
(example versions shown below):

### **PLINK 2.0**
```
PLINK v2.00a3.7LM 64-bit Intel (21 Jan 2024)
```

### **METAL**
```
METAL build 2011-03-25
```

---

## Interpretation Notes

- QQ plots show mild genomic inflation across the range  
- Strong deviation at the tail suggests potential true biological signals

---

## References

**PLINK 2.0**

> Chang CC, Chow CC, Tellier LC, Vattikuti S, Purcell SM, Lee JJ.  
> *Second-generation PLINK: rising to the challenge of larger and richer datasets.*  
> **GigaScience.** 2015;4:7. doi:10.1186/s13742-015-0047-8.

**METAL**

> Willer CJ, Li Y, Abecasis GR.  
> *METAL: fast and efficient meta-analysis of genomewide association scans.*  
> **Bioinformatics.** 2010;26(17):2190–2191. doi:10.1093/bioinformatics/btq340.

---

## Contact

For questions or collaboration, please contact:

**Cynthia Sandor**  
Principal Investigator  
Imperial College London  

