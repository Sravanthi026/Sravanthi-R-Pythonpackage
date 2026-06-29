# Question 4: TLG - Adverse Events Reporting

## Overview
Generate publication-ready Tables, Listings, and Graphs (TLGs) for adverse events analysis using {gtsummary} and {ggplot2}.

## Deliverables

### 1. AE Summary Table (01_create_ae_summary_table.R)
- Treatment-emergent adverse events by treatment arm
- Rows: System Organ Class (SOC) and Preferred Term (PT)
- Columns: Treatment groups with counts and percentages
- Output: ae_summary_table.html

### 2. Visualizations (02_create_visualizations.R)
**Plot 1: AE Severity Distribution**
- Heatmap of severity (MILD, MODERATE, SEVERE) by treatment arm

**Plot 2: Top 10 AE Incidence with 95% CI**
- Bar chart with confidence intervals
- Output: PNG files

### 3. Listings (03_create_listings.R)
- Detailed subject-level AE listing
- Variables: USUBJID, ACTARM, AETERM, AESEV, AEREL, AESTDTC, AEENDTC
- Filtered for treatment-emergent events
- Output: ae_listings.html
- **Also exports adae.csv for Questions 5 and 6**

## Input Data
- pharmaverseadam::adae (Adverse Events Analysis dataset)
- pharmaverseadam::adsl (Subject Level Analysis dataset)

## Usage

Run the Question 4 scripts in order:

```r
source("question_4_tlg/01_create_ae_summary_table.R")
source("question_4_tlg/02_create_visualizations.R")
source("question_4_tlg/03_create_listings.R")
```

The final script also exports `adae.csv` for use in Questions 5 and 6.

