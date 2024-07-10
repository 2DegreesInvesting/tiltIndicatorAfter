best_case_worst_case_transition_risk_profile_at_company_level <- function(data) {
  product <- data |>
    unnest_product()

  avg_best_case_worst_case_at_product_level <- product |>
    create_avg_transition_risk_best_case_worst_case_at_product_level() |>
    prepare_for_join_at_company_level_transition_risk()

  avg_best_case <- prepare_avg_best_case_join_table_transition_risk(
    avg_best_case_worst_case_at_product_level
  )
  avg_worst_case <- prepare_avg_worst_case_join_table_transition_risk(
    avg_best_case_worst_case_at_product_level
  )

  company <- data |>
    unnest_company() |>
    left_join(avg_best_case, by = c(col_companies_id(),
      "benchmark_tr_score_avg" = col_transition_risk_grouped_by()
    )) |>
    left_join(avg_worst_case, by = c(col_companies_id(),
      "benchmark_tr_score_avg" = col_transition_risk_grouped_by()
    )) |>
    polish_transition_risk_best_case_worst_case_at_company_level()

  tilt_profile(nest_levels(product, company))
}

create_avg_transition_risk_best_case_worst_case_at_product_level <- function(data) {
  crucial_cols <- c(
    col_companies_id(),
    col_europages_product(),
    col_transition_risk_grouped_by(),
    col_transition_risk_category(),
    "transition_risk_score"
  )
  check_crucial_cols(data, crucial_cols)

  data |>
    select(all_of(crucial_cols)) |>
    compute_min_risk_category_per_company_benchmark(
      col_transition_risk_category(),
      col_transition_risk_grouped_by()
    ) |>
    compute_max_risk_category_per_company_benchmark(
      col_transition_risk_category(),
      col_transition_risk_grouped_by()
    ) |>
    add_avg_transition_risk() |>
    add_avg_transition_risk_best_case() |>
    add_avg_transition_risk_worst_case()
}

add_avg_transition_risk <- function(data) {
  data |>
    add_avg_col(
      "avg_transition_risk",
      "transition_risk_score",
      col_transition_risk_grouped_by(),
      col_transition_risk_category()
    )
}

add_avg_transition_risk_best_case <- function(data) {
  data |>
    add_avg_case_col_if_risk_category_match(
      "avg_transition_risk_best_case",
      col_transition_risk_category(),
      "min_risk_category_per_company_benchmark",
      "avg_transition_risk"
    )
}

add_avg_transition_risk_worst_case <- function(data) {
  data |>
    add_avg_case_col_if_risk_category_match(
      "avg_transition_risk_worst_case",
      col_transition_risk_category(),
      "max_risk_category_per_company_benchmark",
      "avg_transition_risk"
    )
}

prepare_avg_worst_case_join_table_transition_risk <- function(data) {
  data |>
    prepare_avg_best_case_join_table(
      "avg_transition_risk_best_case",
      "avg_transition_risk_worst_case"
    )
}

prepare_avg_best_case_join_table_transition_risk <- function(data) {
  data |>
    prepare_avg_best_case_join_table(
      "avg_transition_risk_worst_case",
      "avg_transition_risk_best_case"
    )
}

prepare_for_join_at_company_level_transition_risk <- function(data) {
  data |>
    select(-c(
      col_transition_risk_category(),
      col_europages_product(),
      "avg_transition_risk",
      "transition_risk_score",
      "max_risk_category_per_company_benchmark",
      "min_risk_category_per_company_benchmark"
    )) |>
    distinct()
}

polish_transition_risk_best_case_worst_case_at_company_level <- function(data) {
  rename(data, avg_transition_risk_equal_weight = "transition_risk_score_avg")
}

add_avg_col <- function(data,
                        avg_col,
                        col,
                        group_by,
                        risk_category) {
  mutate(data,
    {{ avg_col }} := ifelse(is.na(.data[[col]]),
      NA_real_,
      mean(.data[[col]], na.rm = TRUE)
    ),
    .by = c(
      col_companies_id(),
      group_by,
      risk_category
    )
  )
}

add_avg_case_col_if_risk_category_match <- function(data,
                                                    avg_case_col,
                                                    risk_category,
                                                    min_max_risk_category,
                                                    avg_col) {
  mutate(
    data,
    {{ avg_case_col }} :=
      ifelse(data[[risk_category]] == data[[min_max_risk_category]],
        data[[avg_col]],
        NA_real_
      )
  )
}

prepare_avg_best_case_join_table <- function(data, case1_col, case2_col) {
  data |>
    select(-c(case1_col)) |>
    filter(!is.na(.data[[case2_col]]))
}
