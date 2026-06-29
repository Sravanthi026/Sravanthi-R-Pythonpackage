library(tidyverse)
library(ggplot2)

#' Create AE Visualizations
#'
#' Generate severity distribution and top AE incidence plots
#'
create_ae_visualizations <- function() {
  adae <- pharmaverseadam::adae
  adsl <- pharmaverseadam::adsl
  
  # Filter treatment-emergent AEs and join with treatment arm
  ae_data <- adae %>%
    filter(
      TRTEMFL == "Y",
      AESEV %in% c("MILD", "MODERATE", "SEVERE")
    )
  
  # Plot 1: AE Severity Distribution Heatmap
  severity_summary <- ae_data %>%
    group_by(AESEV, ACTARM) %>%
    summarise(count = n_distinct(USUBJID), .groups = "drop")
  
  plot1 <- ggplot(severity_summary, aes(x = ACTARM, y = AESEV, fill = count)) +
    geom_tile(color = "white", linewidth = 1) +
    scale_fill_gradient(low = "lightblue", high = "darkblue") +
    labs(
      title = "Adverse Event Severity Distribution by Treatment",
      x = "Treatment Arm",
      y = "Severity",
      fill = "Number of Subjects"
    ) +
    theme_minimal() +
    theme(axis.text = element_text(size = 10))
  
  ggsave("question_4_tlg/outputs/ae_severity_distribution.png", plot1, width = 10, height = 6)
  
  # Plot 2: Top 10 AE Incidence with 95% CI
  n_subjects <- n_distinct(ae_data$USUBJID)
  
  ae_incidence <- ae_data %>%
    group_by(AETERM) %>%
    summarise(
      n_subj = n_distinct(USUBJID),
      .groups = "drop"
    ) %>%
    mutate(
      incidence = n_subj / n_subjects,
      se = sqrt(incidence * (1 - incidence) / n_subjects),
      ci_lower = pmax(0, incidence - 1.96 * se),
      ci_upper = pmin(1, incidence + 1.96 * se)
    ) %>%
    arrange(desc(incidence)) %>%
    slice_head(n = 10)
  
  plot2 <- ggplot(ae_incidence, aes(x = reorder(AETERM, incidence), y = incidence)) +
    geom_col(fill = "steelblue", alpha = 0.7) +
    geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper), width = 0.2) +
    coord_flip() +
    labs(
      title = "Top 10 Adverse Events by Incidence Rate",
      subtitle = "With 95% Confidence Intervals",
      x = "Adverse Event",
      y = "Incidence Rate"
    ) +
    theme_minimal()
  
  ggsave("question_4_tlg/outputs/top_10_ae_incidence.png", plot2, width = 10, height = 7)
  
  cat("Visualizations saved successfully\n")
}

# Execute
create_ae_visualizations()
