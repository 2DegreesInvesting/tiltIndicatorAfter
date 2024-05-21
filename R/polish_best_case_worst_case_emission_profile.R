polish_best_case_worst_case_emission_profile <- function(data) {
  data |>
    select(-c(
      col_min_risk_category_per_company_benchmark(),
      col_max_risk_category_per_company_benchmark(),
      col_best_risk(),
      col_worst_risk(),
      col_count_best_case_products_per_company_benchmark(),
      col_count_worst_case_products_per_company_benchmark()
    )) |>
    rename("amount_of_distinct_products" = col_n_distinct_products()) |>
    distinct()
}
