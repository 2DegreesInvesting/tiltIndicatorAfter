#' Creates final output of istr company level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param istr_prod A dataframe like [istr_product]
#' @param comp A dataframe like [ep_companies]
#' @param istr_comp A dataframe like [istr_company]
#' @param eco_inputs A dataframe like [ecoinvent_inputs]
#'
#' @return A dataframe that prepares the final output of ictr_company
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' istr_product <- istr_product
#' ep_companies <- ep_companies
#' istr_company <- istr_company
#' ecoinvent_inputs <- ecoinvent_inputs
#'
#' istr_company_final <- prepare_istr_company(
#'   istr_company,
#'   istr_product,
#'   ep_companies,
#'   ecoinvent_activities,
#'   matches_mapper,
#'   ecoinvent_inputs
#' )
#' istr_company_final
prepare_istr_company <- function(istr_comp, istr_prod, comp, eco_activities, match_mapper, eco_inputs) {
  inter_result <- prepare_istr_product(istr_prod, comp, eco_activities, match_mapper, eco_inputs) |>
    select(
      "companies_id", "company_name", "company_city", "country", "postcode",
      "address", "main_activity", "matching_certainty_company_average"
    ) |>
    distinct()

  istr_comp |>
    left_join(inter_result, by = "companies_id") |>
    distinct() |>
    rename_istr_company() |>
    mutate(scenario = ifelse(.data$scenario == "1.5c rps", "IPR 1.5c RPS", .data$scenario)) |>
    mutate(scenario = ifelse(.data$scenario == "nz 2050", "WEO NZ 2050", .data$scenario)) |>
    relocate_istr_company() |>
    arrange(.data$companies_id)
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
      "companies_id", "company_name", "company_city", "country", "ISTR_share",
      "ISTR_risk_category", "scenario", "year", "matching_certainty_company_average",
      "postcode", "address", "main_activity"
    )
}
