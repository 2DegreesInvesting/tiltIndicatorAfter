#' Creates final output of Emissions Profile product level results
#'
#' @return A dataframe
#'
#' @keywords internal
#' @examples
#' # See examples in `?profile_emissions`
polish_emissions_profile_product <- function(ep_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) {
  ep_prod <- sanitize_isic(ep_prod)

  prepare_inter_emissions_profile(ep_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) |>
    relocate_emissions_profile_product() |>
    rename_emissions_profile_product() |>
    mutate(benchmark = ifelse(is.na(.data$PCTR_risk_category), NA, .data$benchmark), .by = c("companies_id")) |>
    select(-c(
      "matching_certainty_num", "avg_matching_certainty_num", "co2_footprint", "extra_rowid"
    )) |>
    arrange(.data$country) |>
    distinct() |>
    rename_118()
}

rename_emissions_profile_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      benchmark = "grouped_by",
      PCTR_risk_category = "risk_category",
      ep_product = "clustered",
      isic_4digit_name = "isic_4digit_name_ecoinvent",
      ei_geography = "geography"
    )
}

relocate_emissions_profile_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "grouped_by",
      "clustered", "activity_name", "reference_product_name",
      "unit", "multi_match", "matching_certainty", "avg_matching_certainty",
      "co2_footprint", "tilt_sector", "tilt_subsector", "isic_4digit", "isic_4digit_name_ecoinvent",
      "company_city", "postcode", "address", "main_activity", "activity_uuid_product_uuid"
    )
}
