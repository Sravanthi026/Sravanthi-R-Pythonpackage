library(tidyverse)
library(admiral)

#' Create ADaM ADSL Dataset
#'
#' Derives Subject Level Analysis dataset with key clinical variables
#'
#' @return tibble with ADSL dataset
#'
create_adsl <- function() {
  # Load SDTM domains
  dm <- pharmaversesdtm::dm
  vs <- pharmaversesdtm::vs
  ex <- pharmaversesdtm::ex
  ds <- pharmaversesdtm::ds
  ae <- pharmaversesdtm::ae

  # Start with DM domain
  adsl <- dm %>%
    mutate(
      # AGEGR9: Age grouping
      AGEGR9 = case_when(
        AGE < 18 ~ "<18",
        AGE >= 18 & AGE <= 50 ~ "18-50",
        AGE > 50 ~ ">50",
        TRUE ~ NA_character_
      ),
      AGEGR9N = case_when(
        AGEGR9 == "<18" ~ 1,
        AGEGR9 == "18-50" ~ 2,
        AGEGR9 == ">50" ~ 3,
        TRUE ~ NA_real_
      )
    )

  # TRTSDTM: Treatment start datetime from EX domain
  ex_trt <- ex %>%
    group_by(USUBJID) %>%
    arrange(EXSTDTC) %>%
    slice(1) %>%
    ungroup() %>%
    mutate(
      TRTSDTM = as.POSIXct(paste0(EXSTDTC, " 08:00:00")),
      TRTSTMF = "08:00:00"
    ) %>%
    select(USUBJID, TRTSDTM, TRTSTMF)

  adsl <- adsl %>%
    left_join(ex_trt, by = "USUBJID")

  # ITTFL: ITT population flag (any treatment exposure)
  ittfl <- ex %>%
    distinct(USUBJID) %>%
    mutate(ITTFL = "Y")

  adsl <- adsl %>%
    left_join(ittfl, by = "USUBJID") %>%
    mutate(ITTFL = coalesce(ITTFL, "N"))

  # ABNSBPFL: Abnormal baseline BP flag
  vs_bp <- vs %>%
    filter(VSTESTCD == "SYSBP") %>%
    filter(VSBLFL == "Y") %>%
    group_by(USUBJID) %>%
    slice(1) %>%
    ungroup() %>%
    mutate(
      ABNSBPFL = case_when(
        VSSTRESN < 100 | VSSTRESN >= 140 ~ "Y",
        TRUE ~ "N"
      )
    ) %>%
    select(USUBJID, ABNSBPFL)

  adsl <- adsl %>%
    left_join(vs_bp, by = "USUBJID") %>%
    mutate(ABNSBPFL = coalesce(ABNSBPFL, "N"))

  # LSTALVDT: Last known alive date (max date across domains)
  vs_dates <- vs %>% distinct(USUBJID, VSDTC) %>% rename(LSTALVDT = VSDTC)
  ae_dates <- ae %>% distinct(USUBJID, AESTDTC) %>% rename(LSTALVDT = AESTDTC)
  ds_dates <- ds %>% distinct(USUBJID, DSDTC) %>% rename(LSTALVDT = DSDTC)
  ex_dates <- ex %>% distinct(USUBJID, EXENDTC) %>% rename(LSTALVDT = EXENDTC)

  all_dates <- bind_rows(vs_dates, ae_dates, ds_dates, ex_dates) %>%
    group_by(USUBJID) %>%
    arrange(desc(LSTALVDT)) %>%
    slice(1) %>%
    ungroup()

  adsl <- adsl %>%
    left_join(all_dates, by = "USUBJID")

  # CARPOPFL: Cardiac adverse event flag
  cardiac_ae <- ae %>%
    filter(grepl("CARDIAC|HEART", AESOC, ignore.case = TRUE)) %>%
    distinct(USUBJID) %>%
    mutate(CARPOPFL = "Y")

  adsl <- adsl %>%
    left_join(cardiac_ae, by = "USUBJID") %>%
    mutate(CARPOPFL = coalesce(CARPOPFL, "N"))

  return(adsl)
}

# Execute
adsl <- create_adsl()
