## Software

We used the following software versions:

- **PLINK 2.0** (second-generation PLINK)  
  - Example version: `plink2 --version` → `PLINK v2.00a3.7LM` (or similar; please record the exact version you used)
- **METAL** for meta-analysis of GWAS summary statistics  
  - Example build date: `2011-03-25` (as reported when launching `metal`)

Exact versions should be reported from the environment used to run the analyses.

### Running the analyses

1. **UK Biobank GWAS**

   ```bash
   bash scripts/gwas_ukbb.sh
