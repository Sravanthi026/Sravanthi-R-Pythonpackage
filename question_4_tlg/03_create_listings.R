library(tidyverse)
library(gt)
library(pharmaverseadam)

#-------------------------------------------------------
# Create AE Listings
#-------------------------------------------------------

create_ae_listings <- function() {
  
  adae <- pharmaverseadam::adae
  
  # Treatment-emergent adverse events
  ae_listing <- adae %>%
    filter(TRTEMFL == "Y") %>%
    select(
      USUBJID,
      ACTARM,
      AETERM,
      AESOC,
      AESEV,
      AEREL,
      AESTDTC,
      AEENDTC
    ) %>%
    arrange(
      USUBJID,
      AESTDTC
    ) %>%
    rename(
      `Subject ID` = USUBJID,
      `Treatment Arm` = ACTARM,
      `Preferred Term` = AETERM,
      `System Organ Class` = AESOC,
      `Severity` = AESEV,
      `Relationship` = AEREL,
      `Start Date` = AESTDTC,
      `End Date` = AEENDTC
    )
  
  # Create GT table
  listing_tbl <-
    ae_listing %>%
    gt() %>%
    tab_header(
      title = "Treatment-Emergent Adverse Events",
      subtitle = "Subject-Level AE Listing"
    ) %>%
    tab_options(
      table.width = pct(100)
    )
  
  # Create output directory if required
  dir.create(
    "question_4_tlg/outputs",
    recursive = TRUE,
    showWarnings = FALSE
  )
  
  # Save listing
  gtsave(
    listing_tbl,
    "question_4_tlg/outputs/ae_listings.html"
  )
  
  #-------------------------------------------------------
  # Export ADAE
  #-------------------------------------------------------
  
  dir.create(
    "question_5_api/data",
    recursive = TRUE,
    showWarnings = FALSE
  )
  
  dir.create(
    "question_6_genai/data",
    recursive = TRUE,
    showWarnings = FALSE
  )
  
  adae_export <-
    adae %>%
    select(
      USUBJID,
      ACTARM,
      AETERM,
      AESOC,
      AESEV,
      AEREL,
      AESTDTC,
      AEENDTC,
      TRTEMFL
    )
  
  write.csv(
    adae_export,
    "question_5_api/data/adae.csv",
    row.names = FALSE
  )
  
  write.csv(
    adae_export,
    "question_6_genai/data/adae.csv",
    row.names = FALSE
  )
  
  cat("AE listing saved successfully.\n")
  cat("ADAE exported successfully.\n")
  
  return(listing_tbl)
}

#-------------------------------------------------------
# Execute
#-------------------------------------------------------

create_ae_listings()