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

relocate_trs_columns <- function(columns) {
  c(
    "companies_id",
    "company_name",
    "country",
    "benchmark_tr_score",
    columns
  )
}

product_level_trs_ranking_reduction_columns <- function() {
  c(
    "transition_risk_score",
    "profile_ranking",
    "reduction_targets"
  )
}

trs_company_columns <- function() {
  c(
    "companies_id",
    "company_name",
    "country",
    "company_city",
    "benchmark_tr_score",
    "postcode",
    "address",
    "main_activity"
  )
}

trs_company_avg_columns <- function() {
  c(
    "transition_risk_score_avg",
    "profile_ranking_avg",
    "reduction_targets_avg"
  )
}

trs_company_output_columns <- function() {
  c(
    trs_company_columns(),
    trs_company_avg_columns()
  )
}

trs_product_output_columns <- function() {
  c(
    common_columns_emissions_sector(),
    product_level_trs_ranking_reduction_columns(),
    "benchmark_tr_score"
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
