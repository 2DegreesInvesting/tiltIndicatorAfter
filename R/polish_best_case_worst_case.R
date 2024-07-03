polish_best_case_worst_case <- function(data) {
  data |>
    select(-c(
      "min_risk_category_per_company_benchmark",
      "max_risk_category_per_company_benchmark",
      "best_risk",
      "worst_risk",
      "count_best_case_products_per_company_benchmark",
      "count_worst_case_products_per_company_benchmark"
    )) |>
    rename(amount_of_distinct_products = "n_distinct_products") |>
    distinct()
}

rename_with_prefix <- function(data, prefix, match = ".") {
  dplyr::rename_with(data, ~paste0(prefix, .x), .cols = tidyselect::matches(match))
}

polish_best_case_worst_case_emissions_profile <- function(data) {
  data |>
    rename_with_prefix("emissions_profile_", match = c("best_case", "worst_case", "equal_weight"))
}

polish_best_case_worst_case_transition_risk_profile <- function(data) {
  data |>
    rename_with_prefix("transition_risk_profile_", match = c("best_case", "worst_case", "equal_weight"))
}

