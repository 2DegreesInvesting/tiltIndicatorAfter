#' Creates final output of pstr company level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pstr_prod A dataframe like [pstr_product]
#' @param comp A dataframe like [ep_companies]
#' @param pstr_comp A dataframe like the corresponding output at company level
#'   from tiltIndicator.
#'
#' @return A dataframe that prepares the final output of pstr_company
#'
#' @export
#'
#' @examples
#' company <- unnest_company(toy_sector_profile_upstream_output())
#' product <- unnest_product(toy_sector_profile_upstream_output())
#'
#' prepare_pstr_company(
#'   company |> head(3),
#'   product |> head(3),
#'   ep_companies |> head(3),
#'   ecoinvent_activities |> head(3),
#'   matches_mapper |> head(3)
#' )
prepare_pstr_company <- function(pstr_comp, pstr_prod, comp, eco_activities, match_mapper) {
  pstr_comp <- sector_profile_any_polish_output_at_company_level(pstr_comp)

  inter_result <- prepare_inter_pstr_product(pstr_prod, comp, eco_activities, match_mapper) |>
    select("companies_id", "company_name", "company_city", "country", "postcode", "address", "main_activity", "avg_matching_certainty") |>
    distinct()

  pstr_comp |>
    left_join(inter_result, by = "companies_id") |>
    rename_pstr_company() |>
    mutate(scenario = recode(.data$scenario, "1.5c rps" = "IPR 1.5c RPS", "nz 2050" = "WEO NZ 2050")) |>
    exclude_rows("PSTR_share") |>
    select(-c("type")) |>
    relocate_pstr_company() |>
    arrange(.data$companies_id) |>
    distinct()
}

rename_pstr_company <- function(data) {
  data |>
    rename(
      PSTR_risk_category = "risk_category",
      PSTR_share = "value",
      matching_certainty_company_average = "avg_matching_certainty"
    )
}

relocate_pstr_company <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "PSTR_share", "PSTR_risk_category",
      "scenario", "year", "matching_certainty_company_average", "company_city", "postcode",
      "address", "main_activity"
    )
}
