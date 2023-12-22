#' Creates final output of istr company level results
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' @inheritParams prepare_ictr_company
#'
#' @return A dataframe that prepares the final output of ictr_company
#'
#' @export
#' @keywords internal
#' @examples
#' # See examples in `?profile_sector_upstream`
prepare_istr_company <- function(istr_comp, istr_prod, comp, eco_activities, match_mapper, eco_inputs, isic_tilt_map) {
  istr_prod <- sanitize_isic(istr_prod)
  istr_comp <- sector_profile_any_polish_output_at_company_level(istr_comp)

  inter_result <- prepare_istr_product(istr_prod, comp, eco_activities, match_mapper, eco_inputs, isic_tilt_map) |>
    select(
      "companies_id", "company_name", "company_city", "country", "postcode",
      "address", "main_activity", "matching_certainty_company_average"
    ) |>
    distinct()

  istr_comp |>
    left_join(inter_result, by = "companies_id") |>
    rename_istr_company() |>
    mutate(scenario = recode(.data$scenario, "1.5c rps" = "IPR 1.5c RPS", "nz 2050" = "WEO NZ 2050")) |>
    exclude_rows("ISTR_share") |>
    select(-c("type")) |>
    relocate_istr_company() |>
    arrange(.data$companies_id) |>
    distinct()
}

rename_istr_company <- function(data) {
  data |>
    rename(
      ISTR_risk_category = "risk_category",
      ISTR_share = "value"
    )
}

relocate_istr_company <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "ISTR_share",
      "ISTR_risk_category", "scenario", "year", "matching_certainty_company_average",
      "company_city", "postcode", "address", "main_activity"
    )
}
