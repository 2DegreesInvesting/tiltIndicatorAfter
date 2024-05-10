best_and_worst_cases <- function(data) {
  data |>
    mutate(amount_of_distinct_products = dplyr::n_distinct(.data$ep_product), .by = "companies_id") |>
    mutate(equal_weight = (1/.data$amount_of_distinct_products)) |>
    lowest_risk_category_per_company_benchmark(.by = c("companies_id", "benchmark")) |>
    highest_risk_category_per_company_benchmark(.by = c("companies_id", "benchmark")) |>
    mutate(dummy_best = ifelse(.data$emission_profile == .data$min_risk_category_per_company_benchmark, 1, 0)) |>
    mutate(dummy_worst = ifelse(.data$emission_profile == .data$max_risk_category_per_company_benchmark, 1, 0)) |>
    mutate(count_best_case_products_per_company_benchmark = sum(.data$dummy_best), .by = c("companies_id", "benchmark")) |>
    mutate(count_worst_case_products_per_company_benchmark = sum(.data$dummy_worst), .by = c("companies_id", "benchmark")) |>
    mutate(best_case = ifelse(.data$count_best_case_products_per_company_benchmark == 0, NA, .data$dummy_best/.data$count_best_case_products_per_company_benchmark)) |>
    mutate(worst_case = ifelse(.data$count_worst_case_products_per_company_benchmark == 0, NA, .data$dummy_worst/.data$count_worst_case_products_per_company_benchmark))
}

lowest_risk_category_per_company_benchmark <- function(data, .by) {
  risk_order <- c("low", "medium", "high")
  mutate(data, min_risk_category_per_company_benchmark = risk_order[which(risk_order %in% .data$emission_profile)[1]], .by = all_of(.by))
}

highest_risk_category_per_company_benchmark <- function(data, .by) {
  risk_order <- c("high", "medium", "low")
  mutate(data, max_risk_category_per_company_benchmark = risk_order[which(risk_order %in% .data$emission_profile)[1]], .by = all_of(.by))
}
