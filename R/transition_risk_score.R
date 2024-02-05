#' Calculate the Transition Risk Score at product and company levels
#' .
#' @param emissions_at_product_level Emissions profile at product level result.
#' @param sector_at_product_level Sector profile at product level result.
#'
#' @export
transition_risk_score <- function(emissions_at_product_level, sector_at_product_level) {
  union_emissions_sector_rows <- get_rows_union_for_common_cols(emissions_at_product_level, sector_at_product_level)
  trs_emissions <- prepare_trs_emissions(emissions_at_product_level)
  trs_sector <- prepare_trs_sector(sector_at_product_level)

  trs_product <- full_join_emmissions_sector(trs_emissions, trs_sector) |>
    create_tr_benchmarks_tr_score() |>
    select(-c("scenario_year", "benchmark")) |>
    left_join(union_emissions_sector_rows,
      by = c("companies_id", "ep_product", "activity_uuid_product_uuid")
    ) |>
    relocate(relocate_trs_product_columns()) |>
    distinct()

  trs_company <- trs_product |>
    select(trs_company_columns()) |>
    create_benchmarks_averages() |>
    select(-c("transition_risk_score", "reduction_targets", "profile_ranking")) |>
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

prepare_trs_emissions <- function(data) {
  select(data, c(
    "companies_id", "benchmark", "profile_ranking", "ep_product",
    "activity_uuid_product_uuid"
  ))
}

prepare_trs_sector <- function(data) {
  data |>
    select(c(
      "companies_id", "scenario", "year", "reduction_targets", "ep_product",
      "activity_uuid_product_uuid"
    )) |>
    mutate(scenario_year = paste(.data$scenario, .data$year, sep = "_")) |>
    select(-c("scenario", "year"))
}

full_join_emmissions_sector <- function(emissions, sector) {
  full_join(emissions, sector,
    by = c("companies_id", "ep_product", "activity_uuid_product_uuid"),
    relationship = "many-to-many"
  )
}

get_rows_union_for_common_cols <- function(emissions_at_product_level, sector_at_product_level) {
  emission_common_columns <- emissions_at_product_level |>
    select(common_columns_emissions_sector()) |>
    distinct()

  sector_common_columns <- sector_at_product_level |>
    select(common_columns_emissions_sector()) |>
    distinct()

  distinct(bind_rows(emission_common_columns, sector_common_columns))
}

relocate_trs_product_columns <- function() {
  c(
    "companies_id", "company_name", "country", "transition_risk_score", "benchmark_tr_score",
    "profile_ranking", "reduction_targets"
  )
}

trs_company_columns <- function() {
  c(
    "companies_id", "company_name", "country", "company_city", "transition_risk_score",
    "benchmark_tr_score", "profile_ranking", "reduction_targets", "postcode", "address",
    "main_activity"
  )
}

common_columns_emissions_sector <- function() {
  c(
    "companies_id", "company_name", "country", "ep_product", "matched_activity_name",
    "matched_reference_product", "unit", "multi_match", "matching_certainty",
    "matching_certainty_company_average", "company_city", "postcode", "address",
    "main_activity", "activity_uuid_product_uuid", "tilt_sector", "tilt_subsector",
    "isic_4digit", "isic_4digit_name", "ei_geography"
  )
}
