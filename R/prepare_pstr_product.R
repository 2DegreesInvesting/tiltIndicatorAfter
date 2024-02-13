#' Creates final output of pstr product level results
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' @inheritParams prepare_ictr_company
#'
#' @return A dataframe that prepares the final output of pstr_product
#'
#' @export
#' @keywords internal
#' @examples
#' # See examples in `?profile_sector_profile`
prepare_pstr_product <- function(pstr_prod, comp, eco_activities, match_mapper, isic_tilt_map) {
  pstr_prod <- sanitize_isic(pstr_prod)

  prepare_inter_pstr_product(pstr_prod, comp, eco_activities, match_mapper, isic_tilt_map) |>
    relocate_pstr_product() |>
    rename_pstr_product() |>
    mutate(scenario = recode(.data$scenario, "1.5c rps" = "IPR 1.5c RPS", "nz 2050" = "WEO NZ 2050")) |>
    select(-c("matching_certainty_num", "avg_matching_certainty_num", "grouped_by", "type", "extra_rowid")) |>
    distinct() |>
    rename_118()
}

rename_pstr_product <- function(data) {
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

relocate_pstr_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "profile_ranking",
      "scenario", "year", "clustered", "activity_name", "reference_product_name",
      "unit", "tilt_sector", "tilt_subsector", "multi_match", "matching_certainty",
      "avg_matching_certainty", "company_city", "postcode", "address", "main_activity",
      "activity_uuid_product_uuid"
    )
}
