#' Creates final output of Emissions Profile Upstream product level results
#'
#' @return A dataframe
#'
#' @keywords internal
#' @examples
#' # See examples in `?profile_emissions_upstream`
polish_emissions_profile_upstream_product <- function(epu_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, ecoinvent_inputs, isic) {
  epu_prod <- sanitize_isic(epu_prod)

  epu_prod |>
    left_join(ecoinvent_inputs, by = "input_activity_uuid_product_uuid") |>
    select(-c("input_activity_uuid_product_uuid", "input_co2_footprint")) |>
    distinct() |>
    left_join(europages_companies, by = "companies_id") |>
    left_join(isic, by = join_by("input_isic_4digit" == "isic_4digit")) |>
    left_join(ecoinvent_activities, by = "activity_uuid_product_uuid") |>
    left_join(ecoinvent_europages, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    add_avg_matching_certainty("completion") |>
    exclude_rows("risk_category") |>
    relocate_emissions_profile_upstream_product() |>
    rename_emissions_profile_upstream_product() |>
    mutate(benchmark = ifelse(is.na(.data$ICTR_risk_category), NA, .data$benchmark), .by = c("companies_id")) |>
    select(-c(
      "matching_certainty_num", "avg_matching_certainty_num", "extra_rowid"
    )) |>
    arrange(.data$country) |>
    distinct() |>
    rename_118()
}

rename_emissions_profile_upstream_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      benchmark = "grouped_by",
      ep_product = "clustered",
      ICTR_risk_category = "risk_category",
      input_name = "exchange_name",
      input_unit = "exchange_unit_name",
      input_isic_4digit_name = "isic_4digit_name_ecoinvent",
      ei_geography = "geography",
      ei_input_geography = "input_geography"
    )
}

relocate_emissions_profile_upstream_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "grouped_by",
      "clustered", "activity_name", "reference_product_name",
      "unit", "multi_match", "matching_certainty", "avg_matching_certainty", "exchange_name",
      "exchange_unit_name", "input_tilt_sector", "input_tilt_subsector", "input_isic_4digit", "isic_4digit_name_ecoinvent",
      "company_city", "postcode", "address", "main_activity", "activity_uuid_product_uuid"
    )
}
