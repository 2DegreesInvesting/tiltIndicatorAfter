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

polish_best_case_worst_case_emissions_profile <- function(data) {
  data |>
    rename(emissions_profile_best_case = "best_case",
           emissions_profile_worst_case = "worst_case",
           emissions_profile_equal_weight = "equal_weight")
}

polish_best_case_worst_case_transition_risk_profile <- function(data) {
  data |>
    rename(transition_risk_profile_best_case = "best_case",
           transition_risk_profile_worst_case = "worst_case",
           transition_risk_profile_equal_weight = "equal_weight")
}

