library(tidyverse)
library(sdtm.oak)
library(admiral)

#' Create SDTM DS Domain
#'
#' Transforms raw disposition data into SDTM-compliant DS domain
#'
#' @return tibble with DS domain data
#'
create_ds_domain <- function() {
  raw_ds <- pharmaverseraw::ds_raw

  ds <- raw_ds %>%
    mutate(
      STUDYID = STUDY,
      DOMAIN = "DS",
      USUBJID = paste0(STUDY, "-", PATNUM),
      DSSEQ = row_number(),
      DSTERM = IT.DSTERM,
      DSDECOD = IT.DSDECOD,
      DSCAT = INSTANCE,
      DSDTC = DSDTCOL,
      DSSTDAT = IT.DSSTDAT
    ) %>%
    select(
      STUDYID,
      DOMAIN,
      USUBJID,
      DSSEQ,
      DSTERM,
      DSDECOD,
      DSCAT,
      DSDTC,
      DSSTDAT
    ) %>%
    arrange(USUBJID, DSSEQ) %>%
    distinct()

  return(ds)
}

# Execute
ds_domain <- create_ds_domain()
head(ds_domain)

