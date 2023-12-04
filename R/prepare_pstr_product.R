#' Creates final output of pstr product level results
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pstr_prod A dataframe like [pstr_product]
#' @param comp A dataframe like [ep_companies]
#'
#' @return A dataframe that prepares the final output of pstr_product
#'
#' @export
#' @keywords internal
#' @examples
#' See examples in `?profile_sector`
prepare_pstr_product <- function(pstr_prod, comp, eco_activities, match_mapper) {
  deprecate_soft(
    "0.0.0.9011",
    "prepare_pstr_product()",
    "profile_sector()"
  )

  prepare_inter_pstr_product(pstr_prod, comp, eco_activities, match_mapper) |>
    relocate_pstr_product() |>
    rename_pstr_product() |>
    mutate(scenario = recode(.data$scenario, "1.5c rps" = "IPR 1.5c RPS", "nz 2050" = "WEO NZ 2050")) |>
    select(-c("matching_certainty_num", "avg_matching_certainty_num", "grouped_by", "type")) |>
    distinct()
}

rename_pstr_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      PSTR_risk_category = "risk_category",
      ep_product = "clustered"
    )
}

relocate_pstr_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "scenario", "year",
      "clustered", "activity_name", "reference_product_name",
      "unit", "tilt_sector", "tilt_subsector", "multi_match", "matching_certainty", "avg_matching_certainty",
      "company_city", "postcode", "address", "main_activity",
      "activity_uuid_product_uuid"
    )
}
