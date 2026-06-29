# Question 2: SDTM DS Domain Creation using {sdtm.oak}

## Overview
Create a Disposition (DS) domain dataset from raw clinical trial data following CDISC SDTM standards using the {sdtm.oak} package.

## Objective
Transform raw disposition data into a structured SDTM DS domain with proper standardization, sequencing, and date handling.

## Input Data
- `pharmaverseraw::ds_raw` - Raw disposition records
- Study controlled terminology (study_ct)

## Output Variables
STUDYID, DOMAIN, USUBJID, DSSEQ, DSTERM, DSDECOD, DSCAT, VISITNUM, VISIT, DSDTC, DSSTDTC, DSSTDY

## Key Derivations
- DSSEQ: Sequential counter for each subject's disposition records
- DSDECOD: Standardized disposition term (e.g., "COMPLETED", "DISCONTINUED")
- DSSTDY: Study day relative to treatment start

## Usage
```r
source("question_2_sdtm/02_create_ds_domain.R")
adsl_ds <- create_ds_domain()
head(adsl_ds)
```
