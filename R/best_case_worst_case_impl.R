best_case_worst_case_impl <- function(data, col_risk, col_group_by) {
  data |>
    compute_n_distinct_products() |>
    compute_equal_weight() |>
    compute_min_risk_category_per_company_benchmark(col_risk, col_group_by) |>
    compute_max_risk_category_per_company_benchmark(col_risk, col_group_by) |>
    compute_best_risk(col_risk) |>
    compute_worst_risk(col_risk) |>
    compute_count_best_case_products_per_company_benchmark(col_group_by) |>
    compute_count_worst_case_products_per_company_benchmark(col_group_by) |>
    compute_best_case() |>
    compute_worst_case()
}
