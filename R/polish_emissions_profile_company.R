#' Creates final output of Emissions Profile company level results
#'
#' @return A dataframe
#'
#' @keywords internal
#' @examples
#' # See examples in `?profile_emissions`
polish_emissions_profile_company <- function(ep_comp, ep_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) {
  ep_prod <- sanitize_isic(ep_prod)

  inter_result <- prepare_inter_emissions_profile(ep_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) |>
    select("companies_id", "company_name", "company_city", "country", "postcode", "address", "main_activity", "avg_matching_certainty") |>
    distinct()

  ep_comp |>
    add_profile_ranking_average(ep_prod) |>
    left_join(inter_result, by = "companies_id", relationship = "many-to-many") |>
    distinct() |>
    rename_emissions_profile_company() |>
    mutate(
      PCTR_risk_category = ifelse(is.na(.data$matching_certainty_company_average), NA, .data$PCTR_risk_category),
      benchmark = ifelse(is.na(.data$matching_certainty_company_average), NA, .data$benchmark)
    ) |>
    relocate_emissions_profile_company() |>
    arrange(.data$companies_id) |>
    rename_118()
}

rename_emissions_profile_company <- function(data) {
  data |>
    rename(
      PCTR_risk_category = "risk_category",
      benchmark = "grouped_by",
      PCTR_share = "value",
      matching_certainty_company_average = "avg_matching_certainty"
    )
}

relocate_emissions_profile_company <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "PCTR_share", "PCTR_risk_category",
      "benchmark", "co2e_lower", "co2e_upper", "matching_certainty_company_average",
      "company_city", "postcode", "address", "main_activity"
    )
}
