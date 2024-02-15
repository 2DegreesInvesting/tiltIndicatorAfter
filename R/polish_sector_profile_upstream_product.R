#' Creates final output of Sector Profile Upstream product level results
#'
#' @return A dataframe
#'
#' @keywords internal
#' @examples
#' # See examples in `?profile_sector_upstream`
polish_sector_profile_upstream_product <- function(spu_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, ecoinvent_inputs, isic) {
  spu_prod <- sanitize_isic(spu_prod)

  spu_prod |>
    left_join(ecoinvent_inputs, by = "input_activity_uuid_product_uuid") |>
    select(-c("input_activity_uuid_product_uuid", "extra_rowid")) |>
    distinct() |>
    left_join(europages_companies, by = "companies_id") |>
    left_join(isic, by = join_by("input_isic_4digit" == "isic_4digit")) |>
    left_join(ecoinvent_activities, by = "activity_uuid_product_uuid") |>
    left_join(ecoinvent_europages, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    add_avg_matching_certainty("completion") |>
    exclude_rows("risk_category") |>
    relocate_sector_profile_upstream_product() |>
    rename_sector_profile_upstream_product() |>
    mutate(scenario = recode(.data$scenario, "1.5c rps" = "IPR 1.5c RPS", "nz 2050" = "WEO NZ 2050")) |>
    select(-c("matching_certainty_num", "avg_matching_certainty_num", "grouped_by", "type")) |>
    distinct() |>
    arrange(.data$country) |>
    rename_118()
}

rename_sector_profile_upstream_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      ep_product = "clustered",
      ISTR_risk_category = "risk_category",
      input_name = "exchange_name",
      input_unit = "exchange_unit_name",
      input_isic_4digit_name = "isic_4digit_name_ecoinvent",
      ei_geography = "geography",
      ei_input_geography = "input_geography",
      reduction_targets = "profile_ranking"
    )
}

relocate_sector_profile_upstream_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "profile_ranking",
      "scenario", "year", "clustered", "activity_name", "reference_product_name",
      "unit", "tilt_sector", "multi_match", "matching_certainty", "avg_matching_certainty",
      "exchange_name", "exchange_unit_name", "input_tilt_sector", "input_tilt_subsector",
      "company_city", "postcode", "address", "main_activity", "activity_uuid_product_uuid"
    )
}
