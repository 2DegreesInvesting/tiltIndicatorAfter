#' Creates final output of pstr company level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pstr_prod A dataframe like [pstr_product]
#' @param comp A dataframe like [companies]
#' @param pstr_comp A dataframe like [pstr_company]
#'
#' @return A dataframe that prepares the final output of pstr_company
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' pstr_product <- pstr_product
#' companies <- companies
#' pstr_company <- pstr_company
#'
#' pstr_company_final <- prepare_pstr_company(
#'   pstr_company,
#'   pstr_product,
#'   companies,
#'   ecoinvent_activities,
#'   matches_mapper
#' )
#'
#' pstr_company_final
prepare_pstr_company <- function(pstr_comp, pstr_prod, comp, eco_activities, match_mapper) {

  inter_result <- prepare_inter_pstr_product(pstr_prod, comp, eco_activities, match_mapper) |>
    select("companies_id", "company_name", "company_city", "country", "postcode", "address", "main_activity", "avg_matching_certainty") |>
    distinct()

  pstr_company_level <- pstr_comp |>
    left_join(inter_result, by = "companies_id") |>
    rename(
      PSTR_risk_category = "risk_category",
      # No benchmark
      PSTR_share = "value",
      matching_certainty_company_average = "avg_matching_certainty"
    ) |>
    distinct() |>
    mutate(scenario = ifelse(scenario == "1.5c rps", "IPR 1.5c RPS", scenario)) |>
    mutate(scenario = ifelse(scenario == "nz 2050", "WEO NZ 2050", scenario)) |>
    select(-c("type")) |>
    distinct() |>
    relocate(
      "companies_id", "company_name", "country", "PSTR_share", "PSTR_risk_category",
      "scenario", "year", "matching_certainty_company_average", "company_city", "postcode",
      "address", "main_activity"
    ) |>
    arrange(companies_id)
}
