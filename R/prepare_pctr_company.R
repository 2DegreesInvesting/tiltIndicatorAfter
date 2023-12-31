#' Creates final output of pctr company level results
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' @inheritParams prepare_ictr_company
#'
#' @return A dataframe that prepares the final output of pctr_company
#'
#' @export
#' @keywords internal
#' @examples
#' # See examples in `?profile_emissions`
prepare_pctr_company <- function(pctr_comp, pctr_prod, comp, eco_activities, match_mapper, isic_tilt_map) {
  pctr_prod <- sanitize_isic(pctr_prod)

  inter_result <- prepare_inter_pctr_product(pctr_prod, comp, eco_activities, match_mapper, isic_tilt_map) |>
    select("companies_id", "company_name", "company_city", "country", "postcode", "address", "main_activity", "avg_matching_certainty") |>
    distinct()

  pctr_comp |>
    left_join(inter_result, by = "companies_id", relationship = "many-to-many") |>
    distinct() |>
    rename_pctr_company() |>
    mutate(
      PCTR_risk_category = ifelse(is.na(.data$matching_certainty_company_average), NA, .data$PCTR_risk_category),
      benchmark = ifelse(is.na(.data$matching_certainty_company_average), NA, .data$benchmark)
    ) |>
    relocate_pctr_company() |>
    arrange(.data$companies_id)
}

rename_pctr_company <- function(data) {
  data |>
    rename(
      PCTR_risk_category = "risk_category",
      benchmark = "grouped_by",
      PCTR_share = "value",
      matching_certainty_company_average = "avg_matching_certainty"
    )
}

relocate_pctr_company <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "PCTR_share", "PCTR_risk_category",
      "benchmark", "matching_certainty_company_average", "company_city", "postcode",
      "address", "main_activity"
    )
}
