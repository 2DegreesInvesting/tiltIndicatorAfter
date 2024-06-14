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
