#' Creates final output of Sector Profile product level results
#'
#' @return A dataframe
#'
#' @keywords internal
#' @examples
#' # See examples in `?profile_sector_profile`
polish_sector_profile_product <- function(sp_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) {
  sp_prod <- sanitize_isic(sp_prod)

  prepare_inter_sector_profile(sp_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) |>
    relocate_sector_profile_product() |>
    rename_sector_profile_product() |>
    mutate(scenario = ifelse(is.na(scenario), grouped_by, scenario)) |>
    mutate(scenario = recode_scenario(.data$scenario)) |>
    select(-c("matching_certainty_num", "avg_matching_certainty_num", "grouped_by", "type", "extra_rowid")) |>
    distinct() |>
    rename_118()
}

rename_sector_profile_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      PSTR_risk_category = "risk_category",
      ep_product = "clustered",
      isic_4digit_name = "isic_4digit_name_ecoinvent",
      ei_geography = "geography",
      reduction_targets = "profile_ranking"
    )
}

relocate_sector_profile_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "profile_ranking",
      "scenario", "year", "clustered", "activity_name", "reference_product_name",
      "unit", "tilt_sector", "tilt_subsector", "multi_match", "matching_certainty",
      "avg_matching_certainty", "company_city", "postcode", "address", "main_activity",
      "activity_uuid_product_uuid"
    )
}
