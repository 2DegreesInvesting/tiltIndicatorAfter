#' Creates final output of Emissions Profile Upstream company level results
#'
#' @return A dataframe
#'
#' @keywords internal
#' @examples
#' # See examples in `?profile_emissions_upstream`
polish_emissions_profile_upstream_company <- function(epu_comp, epu_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, ecoinvent_inputs, isic) {
  epu_prod <- sanitize_isic(epu_prod)

  inter_result <- polish_emissions_profile_upstream_product(epu_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, ecoinvent_inputs, isic) |>
    select(
      "companies_id", "company_name", "company_city", "country", "postcode",
      "address", "main_activity", "matching_certainty_company_average"
    ) |>
    distinct()

  epu_comp |>
    left_join(inter_result, by = "companies_id") |>
    rename_emissions_profile_upstream_company() |>
    # To check: here ICTR_share is used instead of matching_certainty_company_average
    mutate(
      benchmark = ifelse(is.na(.data$ICTR_share), NA, .data$benchmark),
      ICTR_risk_category = ifelse(is.na(.data$ICTR_share), NA, .data$ICTR_risk_category)
    ) |>
    relocate_emissions_profile_upstream_company() |>
    arrange(.data$companies_id) |>
    distinct() |>
    rename_118()
}

rename_emissions_profile_upstream_company <- function(data) {
  data |>
    rename(
      ICTR_risk_category = "risk_category",
      benchmark = "grouped_by",
      ICTR_share = "value"
    )
}

relocate_emissions_profile_upstream_company <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "company_city", "country", "ICTR_share",
      "ICTR_risk_category", "benchmark", "matching_certainty_company_average",
      "postcode", "address", "main_activity"
    )
}
