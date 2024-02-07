#' Transition Risk Score
#'
#' Calulate Transition Risk Score at product level and company level
#'
#' @param emissions_profile_at_product_level Dataframe. Emissions profile product level output
#' @param sector_profile_at_product_level Dataframe. Sector profile product level output
#'
#' @family top-level functions
#'
#' @export
#'
#' @examples
#' library(dplyr)
#' library(readr, warn.conflicts = FALSE)
#'
#' emissions_profile_at_product_level <- example_emissions_profile_at_product_level()
#' sector_profile_at_product_level <- example_sector_profile_at_product_level()
#'
#' result <- transition_risk_score(emissions_profile_at_product_level, sector_profile_at_product_level)
#'
#' result |> unnest_product()
#'
#' result |> unnest_company()
transition_risk_score <- function(emissions_profile_at_product_level, sector_profile_at_product_level) {
  union_emissions_sector_rows <- get_rows_union_for_common_cols(emissions_profile_at_product_level, sector_profile_at_product_level)
  trs_emissions <- prepare_trs_emissions(emissions_profile_at_product_level)
  trs_sector <- prepare_trs_sector(sector_profile_at_product_level)

  trs_product <- full_join_emmissions_sector(trs_emissions, trs_sector) |>
    create_tr_benchmarks_tr_score() |>
    select(-c("scenario_year", "benchmark")) |>
    left_join(union_emissions_sector_rows,
      by = c("companies_id", "ep_product", "activity_uuid_product_uuid")
    ) |>
    relocate(relocate_trs_columns(product_level_trs_ranking_reduction_columns())) |>
    distinct()

  trs_company <- trs_product |>
    select(trs_company_columns(), product_level_trs_ranking_reduction_columns()) |>
    create_benchmarks_averages() |>
    select(-product_level_trs_ranking_reduction_columns()) |>
    relocate(relocate_trs_columns(trs_company_avg_columns())) |>
    distinct()

  nest_levels(trs_product, trs_company)
}

create_tr_benchmarks_tr_score <- function(data) {
  mutate(data,
    transition_risk_score = ifelse(is.na(.data$profile_ranking) | is.na(.data$reduction_targets), NA,
      (.data$profile_ranking + .data$reduction_targets) / 2
    ),
    benchmark_tr_score = ifelse(is.na(.data$scenario_year) | is.na(.data$benchmark), NA,
      paste(.data$scenario_year, .data$benchmark, sep = "_")
    )
  )
}

create_benchmarks_averages <- function(data) {
  mutate(data,
    transition_risk_score_avg = mean(.data$transition_risk_score, na.rm = TRUE),
    reduction_targets_avg = mean(.data$reduction_targets, na.rm = TRUE),
    profile_ranking_avg = mean(.data$profile_ranking, na.rm = TRUE),
    .by = c("companies_id", "benchmark_tr_score")
  )
}

