best_case_worst_case_avg_reduction_targets <- function(data) {
  product <- data |>
    unnest_product()

  avg_best_case_worst_case_at_product_level <- product |>
    create_avg_reduction_targets_best_case_worst_case_at_product_level() |>
    prepare_for_join_at_company_level_reduction_targets()

  avg_best_case <- prepare_avg_best_case_join_table_reduction_targets(
    avg_best_case_worst_case_at_product_level
  )
  avg_worst_case <- prepare_avg_worst_case_join_table_reduction_targets(
    avg_best_case_worst_case_at_product_level
  )

  company <- data |>
    unnest_company() |>
    left_join(avg_best_case, by = c(
      col_companies_id(),
      "scenario",
      "year"
    )) |>
    left_join(avg_worst_case, by = c(
      col_companies_id(),
      "scenario",
      "year"
    ))

  tilt_profile(nest_levels(product, company))
}

create_avg_reduction_targets_best_case_worst_case_at_product_level <- function(data) {
  crucial_cols <- c(
    col_companies_id(),
    col_europages_product(),
    col_scenario(),
    col_year(),
    col_sector_profile(),
    "reduction_targets"
  )
  check_crucial_cols(data, crucial_cols)

  data |>
    select(all_of(crucial_cols)) |>
    add_scenario_year() |>
    compute_min_risk_category_per_company_benchmark(
      col_sector_profile(),
      "scenario_year"
    ) |>
    compute_max_risk_category_per_company_benchmark(
      col_sector_profile(),
      "scenario_year"
    ) |>
    add_avg_reduction_targets() |>
    add_avg_reduction_targets_best_case() |>
    add_avg_reduction_targets_worst_case()
}

add_avg_reduction_targets <- function(data) {
  data |>
    add_avg_col(
      "avg_reduction_targets",
      "reduction_targets",
      "scenario_year",
      col_sector_profile()
    )
}

add_avg_reduction_targets_best_case <- function(data) {
  data |>
    add_avg_case_col_if_risk_category_match(
      "avg_reduction_targets_best_case",
      col_sector_profile(),
      "min_risk_category_per_company_benchmark",
      "avg_reduction_targets"
    )
}

add_avg_reduction_targets_worst_case <- function(data) {
  data |>
    add_avg_case_col_if_risk_category_match(
      "avg_reduction_targets_worst_case",
      col_sector_profile(),
      "max_risk_category_per_company_benchmark",
      "avg_reduction_targets"
    )
}

prepare_for_join_at_company_level_reduction_targets <- function(data) {
  data |>
    select(-c(
      col_sector_profile(),
      col_europages_product(),
      "scenario_year",
      "avg_reduction_targets",
      "reduction_targets",
      "max_risk_category_per_company_benchmark",
      "min_risk_category_per_company_benchmark"
    )) |>
    distinct()
}

prepare_avg_worst_case_join_table_reduction_targets <- function(data) {
  data |>
    prepare_avg_best_case_join_table(
      "avg_reduction_targets_best_case",
      "avg_reduction_targets_worst_case"
    )
}

prepare_avg_best_case_join_table_reduction_targets <- function(data) {
  data |>
    prepare_avg_best_case_join_table(
      "avg_reduction_targets_worst_case",
      "avg_reduction_targets_best_case"
    )
}

add_scenario_year <- function(data) {
  mutate(data, scenario_year = ifelse(
    is.na(.data$reduction_targets),
    NA_character_,
    paste(.data$scenario, .data$year, sep = "_")
  ))
}
