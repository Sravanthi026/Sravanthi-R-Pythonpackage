library(tidyverse)
library(gtsummary)
library(gt)

#' Create AE Summary Table
#'
#' Generate treatment-emergent AE summary by SOC and PT
#'
create_ae_summary_table <- function() {
  adae <- pharmaverseadam::adae

  # Filter treatment-emergent AEs
  ae_summary <- adae %>%
    filter(TRTEMFL == "Y") %>%
    group_by(AESOC, AETERM, ACTARM) %>%
    summarise(n = n_distinct(USUBJID), .groups = "drop") %>%
    group_by(ACTARM) %>%
    mutate(total = sum(n), pct = round(100 * n / total, 1)) %>%
    ungroup()

  # Create pivot table
  ae_pivot <- ae_summary %>%
    pivot_wider(
      id_cols = c(AESOC, AETERM),
      names_from = ACTARM,
      values_from = c(n, pct),
      values_fill = 0
    ) %>%
    arrange(desc(rowSums(across(starts_with("n_")), na.rm = TRUE)))

  # Create GT table
  table <- ae_pivot %>%
    gt() %>%
    tab_header(
      title = "Treatment-Emergent Adverse Events Summary",
      subtitle = "By System Organ Class and Preferred Term"
    ) %>%
    cols_label(
      AESOC = "System Organ Class",
      AETERM = "Preferred Term"
    )

  # Save as HTML
  gtsave(table, "question_4_tlg/outputs/ae_summary_table.html")

  return(table)
}

# Execute
create_ae_summary_table()
