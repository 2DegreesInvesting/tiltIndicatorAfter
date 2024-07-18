risk_first_occurance <- function(data, col_risk, risk_order) {
  risk_order[which(risk_order %in% data[[col_risk]])[1]]
}

get_risk_match_if_emission_profile_has_no_na <- function(data, col_risk, risk_category_per_company_benchmark) {
  ifelse(is.na(data[[col_risk]]), 0,
    ifelse(data[[col_risk]] == data[[risk_category_per_company_benchmark]], 1, 0)
  )
}

get_case_if_risk_counts_has_no_zero <- function(data, risk, count_risk_cases_per_company_benchmark) {
  ifelse(data[[count_risk_cases_per_company_benchmark]] == 0, NA,
    data[[risk]] / data[[count_risk_cases_per_company_benchmark]]
  )
}

compute_n_distinct_products <- function(data) {
  data |>
    mutate(
      n_distinct_products = n_distinct(.data[[col_europages_product()]], na.rm = TRUE),
      .by = col_companies_id()
    )
}

compute_n_distinct_products_matched <- function(data, col_risk, col_group_by) {
  data |>
    mutate(
      n_distinct_products_matched = n_distinct(.data[[col_europages_product()]][!is.na(.data[[col_risk]])], na.rm = TRUE),
      .by = all_of(c(col_companies_id(), col_group_by))
    )
}

compute_equal_weight <- function(data) {
  mutate(data,
    equal_weight = ifelse(.data$n_distinct_products_matched == 0, NA,
      1 / .data$n_distinct_products_matched
    )
  )
}

compute_min_risk_category_per_company_benchmark <- function(data, col_risk, col_group_by) {
  mutate(data,
    min_risk_category_per_company_benchmark = risk_first_occurance(
      .data,
      col_risk = col_risk,
      risk_order = c("low", "medium", "high")
    ),
    .by = all_of(c(col_companies_id(), col_group_by))
  )
}

compute_max_risk_category_per_company_benchmark <- function(data, col_risk, col_group_by) {
  mutate(data,
    max_risk_category_per_company_benchmark = risk_first_occurance(
      .data,
      col_risk = col_risk,
      risk_order = c("high", "medium", "low")
    ),
    .by = all_of(c(col_companies_id(), col_group_by))
  )
}

compute_best_risk <- function(data, col_risk) {
  mutate(data,
    best_risk = get_risk_match_if_emission_profile_has_no_na(
      .data, col_risk,
      "min_risk_category_per_company_benchmark"
    )
  )
}

compute_worst_risk <- function(data, col_risk) {
  mutate(data,
    worst_risk = get_risk_match_if_emission_profile_has_no_na(
      .data, col_risk,
      "max_risk_category_per_company_benchmark"
    )
  )
}

compute_count_best_case_products_per_company_benchmark <- function(data, col_group_by) {
  mutate(data,
    count_best_case_products_per_company_benchmark = sum(.data$best_risk),
    .by = all_of(c(col_companies_id(), col_group_by))
  )
}

compute_count_worst_case_products_per_company_benchmark <- function(data, col_group_by) {
  mutate(data,
    count_worst_case_products_per_company_benchmark = sum(.data$worst_risk),
    .by = all_of(c(col_companies_id(), col_group_by))
  )
}

compute_best_case <- function(data) {
  mutate(data,
    best_case = get_case_if_risk_counts_has_no_zero(
      .data, "best_risk",
      "count_best_case_products_per_company_benchmark"
    )
  )
}

compute_worst_case <- function(data) {
  mutate(data,
    worst_case = get_case_if_risk_counts_has_no_zero(
      .data, "worst_risk",
      "count_worst_case_products_per_company_benchmark"
    )
  )
}

check_crucial_cols <- function(data, crucial_cols) {
  walk(crucial_cols, ~ check_matches_name(data, .x))
}
