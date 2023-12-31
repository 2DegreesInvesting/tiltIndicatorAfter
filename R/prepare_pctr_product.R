#' Creates final output of pctr product level results
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' @inheritParams prepare_ictr_company
#'
#' @return A dataframe that prepares the final output of pctr_product
#'
#' @export
#' @keywords internal
#' @examples
#' # See examples in `?profile_emissions`
prepare_pctr_product <- function(pctr_prod, comp, eco_activities, match_mapper, isic_tilt_map) {
  pctr_prod <- sanitize_isic(pctr_prod)

  prepare_inter_pctr_product(pctr_prod, comp, eco_activities, match_mapper, isic_tilt_map) |>
    relocate_pctr_product() |>
    rename_pctr_product() |>
    mutate(benchmark = ifelse(is.na(.data$PCTR_risk_category), NA, .data$benchmark), .by = c("companies_id")) |>
    select(-c(
      "matching_certainty_num", "avg_matching_certainty_num", "co2_footprint"
    )) |>
    arrange(.data$country) |>
    distinct()
}

rename_pctr_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      benchmark = "grouped_by",
      PCTR_risk_category = "risk_category",
      ep_product = "clustered",
      isic_4digit_name = "isic_4digit_name_ecoinvent"
    )
}

# #TODO: column co2 footprint is not required in the final output results
relocate_pctr_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "grouped_by",
      "clustered", "activity_name", "reference_product_name",
      "unit", "multi_match", "matching_certainty", "avg_matching_certainty",
      "co2_footprint", "tilt_sector", "tilt_subsector", "isic_4digit", "isic_4digit_name_ecoinvent",
      "company_city", "postcode", "address", "main_activity", "activity_uuid_product_uuid"
    )
}
