# Question 3: ADaM ADSL Dataset Creation

## Overview
Create an Analysis Data Model (ADaM) Subject Level Analysis (ADSL) dataset using {admiral} with derived variables following regulatory standards.

## Objective
Build ADSL dataset with 6 key derived variables for clinical trial analysis, sourced from multiple SDTM domains.

## Derived Variables

1. **AGEGR9 / AGEGR9N** - Age grouping
   - <18, 18-50, >50

2. **TRTSDTM / TRTSTMF** - Treatment start datetime
   - Source: EX domain
   - Imputation: First dose date with time imputation

3. **ITTFL** - ITT (Intent-to-Treat) population flag
   - Y if subject received any treatment exposure

4. **ABNSBPFL** - Abnormal baseline blood pressure flag
   - Y if SYSBP <100 or >=140 mmHg

5. **LSTALVDT** - Last known alive date
   - Max of: vitals date, AE date, disposition date, exposure date

6. **CARPOPFL** - Cardiac adverse event flag
   - Y if any cardiac-related SOC in AE domain

## Input Data
- pharmaversesdtm::dm (Demography)
- pharmaversesdtm::vs (Vital Signs)
- pharmaversesdtm::ex (Exposure)
- pharmaversesdtm::ds (Disposition)
- pharmaversesdtm::ae (Adverse Events)

## Usage
```r
source("question_3_adam/create_adsl.R")
adsl <- create_adsl()
head(adsl)
```
