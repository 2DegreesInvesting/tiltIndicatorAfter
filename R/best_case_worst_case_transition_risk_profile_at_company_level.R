best_case_worst_case_transition_risk_profile_at_company_level <- function(data) {
  product <- data |>
    unnest_product()

  avg_best_case_worst_case_at_product_level <- product |>
    create_avg_best_case_worst_case_at_product_level() |>
    prepare_for_join_at_company_level()

  company <- data |>
    unnest_company() |>
    left_join(avg_best_case_worst_case_at_product_level, by = c(col_companies_id(),
      "benchmark_tr_score_avg" = col_transition_risk_grouped_by()
    )) |>
    polish_best_case_worst_case_transition_risk_at_company_level()

  tilt_profile(nest_levels(product, company))
}

create_avg_best_case_worst_case_at_product_level <- function(data) {
  crucial_cols <- c(
    col_companies_id(),
    col_europages_product(),
    col_transition_risk_grouped_by(),
    col_transition_risk_category(),
    "amount_of_distinct_products"
  )
  check_crucial_cols(data, crucial_cols)

  data |>
    select(crucial_cols) |>
    count_min_risk_category_per_company_benchmark() |>
    count_max_risk_category_per_company_benchmark() |>
    add_avg_transition_risk_best_case() |>
    add_avg_transition_risk_worst_case()
}

count_min_risk_category_per_company_benchmark <- function(data) {
  mutate(data,
    n_min_risk_category_per_company_benchmark =
      sum_transition_risk_categories(.data, c("low", "medium", "high")),
    .by = c(col_companies_id(), col_transition_risk_grouped_by())
  )
}

count_max_risk_category_per_company_benchmark <- function(data) {
  mutate(data,
    n_max_risk_category_per_company_benchmark =
      sum_transition_risk_categories(.data, c("high", "medium", "low")),
    .by = c(col_companies_id(), col_transition_risk_grouped_by())
  )
}

add_avg_transition_risk_best_case <- function(data) {
  mutate(data,
    avg_transition_risk_best_case =
      (.data$n_min_risk_category_per_company_benchmark /
        .data$amount_of_distinct_products)
  )
}

add_avg_transition_risk_worst_case <- function(data) {
  mutate(data,
    avg_transition_risk_worst_case =
      (.data$n_max_risk_category_per_company_benchmark /
        .data$amount_of_distinct_products)
  )
}

sum_transition_risk_categories <- function(data, risk_order) {
  sum(data$transition_risk_category ==
    risk_first_occurance(
      data,
      col_transition_risk_category(),
      risk_order
    ), na.rm = TRUE)
}

prepare_for_join_at_company_level <- function(data) {
  data |>
    select(-c(
      col_transition_risk_category(),
      col_europages_product(),
      "amount_of_distinct_products",
      "n_min_risk_category_per_company_benchmark",
      "n_max_risk_category_per_company_benchmark"
    )) |>
    distinct()
}

polish_best_case_worst_case_transition_risk_at_company_level <- function(data) {
  rename(data, avg_transition_risk_equal_weight = "transition_risk_score_avg")
}
