best_case_worst_case_avg_profile_ranking <- function(data) {
  product <- data |>
    unnest_product()

  avg_best_case_worst_case_at_product_level <- product |>
    create_avg_profile_ranking_best_case_worst_case_at_product_level() |>
    prepare_for_join_at_company_level_profile_ranking()

  avg_best_case <- prepare_avg_best_case_join_table_profile_ranking(
    avg_best_case_worst_case_at_product_level
  )
  avg_worst_case <- prepare_avg_worst_case_join_table_profile_ranking(
    avg_best_case_worst_case_at_product_level
  )

  company <- data |>
    unnest_company() |>
    left_join(avg_best_case, by = c(
      col_companies_id(),
      col_emission_grouped_by()
    )) |>
    left_join(avg_worst_case, by = c(
      col_companies_id(),
      col_emission_grouped_by()
    ))

  tilt_profile(nest_levels(product, company))
}

create_avg_profile_ranking_best_case_worst_case_at_product_level <- function(data) {
  crucial_cols <- c(
    col_companies_id(),
    col_europages_product(),
    col_emission_grouped_by(),
    col_emission_profile(),
    "profile_ranking"
  )
  check_crucial_cols(data, crucial_cols)

  data |>
    select(all_of(crucial_cols)) |>
    compute_min_risk_category_per_company_benchmark(
      col_emission_profile(),
      col_emission_grouped_by()
    ) |>
    compute_max_risk_category_per_company_benchmark(
      col_emission_profile(),
      col_emission_grouped_by()
    ) |>
    add_avg_profile_ranking() |>
    add_avg_profile_ranking_best_case() |>
    add_avg_profile_ranking_worst_case()
}

add_avg_profile_ranking <- function(data) {
  data |>
    add_avg_col(
      "avg_profile_ranking",
      "profile_ranking",
      col_emission_grouped_by(),
      col_emission_profile()
    )
}

add_avg_profile_ranking_best_case <- function(data) {
  data |>
    add_avg_case_col_if_risk_category_match(
      "avg_profile_ranking_best_case",
      "emission_profile",
      "min_risk_category_per_company_benchmark",
      "avg_profile_ranking"
    )
}

add_avg_profile_ranking_worst_case <- function(data) {
  data |>
    add_avg_case_col_if_risk_category_match(
      "avg_profile_ranking_worst_case",
      "emission_profile",
      "max_risk_category_per_company_benchmark",
      "avg_profile_ranking"
    )
}

prepare_for_join_at_company_level_profile_ranking <- function(data) {
  data |>
    select(-all_of(c(
      col_emission_profile(),
      col_europages_product(),
      "avg_profile_ranking",
      "profile_ranking",
      "max_risk_category_per_company_benchmark",
      "min_risk_category_per_company_benchmark"
    ))) |>
    distinct()
}

prepare_avg_worst_case_join_table_profile_ranking <- function(data) {
  data |>
    prepare_avg_best_case_join_table(
      "avg_profile_ranking_best_case",
      "avg_profile_ranking_worst_case"
    )
}

prepare_avg_best_case_join_table_profile_ranking <- function(data) {
  data |>
    prepare_avg_best_case_join_table(
      "avg_profile_ranking_worst_case",
      "avg_profile_ranking_best_case"
    )
}
