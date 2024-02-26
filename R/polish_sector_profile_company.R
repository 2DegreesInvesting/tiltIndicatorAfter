#' Creates final output of Sector Profile company level results
#'
#' @return A dataframe
#'
#' @keywords internal
#' @examples
#' # See examples in `?profile_sector_profile`
polish_sector_profile_company <- function(sp_comp, sp_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) {
  sp_prod <- sanitize_isic(sp_prod)
  sp_comp <- sp_comp |>
    add_profile_ranking_average(sp_prod) |>
    sector_profile_any_polish_output_at_company_level()

  inter_result <- prepare_inter_sector_profile(sp_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) |>
    select("companies_id", "company_name", "company_city", "country", "postcode", "address", "main_activity", "avg_matching_certainty") |>
    distinct()

  sp_comp |>
    left_join(inter_result, by = "companies_id") |>
    rename_sector_profile_company() |>
    mutate(scenario = recode(.data$scenario, "1.5c rps" = "IPR 1.5c RPS", "nz 2050" = "WEO NZ 2050")) |>
    exclude_rows("PSTR_share") |>
    select(-c("type")) |>
    relocate_sector_profile_company() |>
    arrange(.data$companies_id) |>
    distinct() |>
    rename_118()
}

rename_sector_profile_company <- function(data) {
  data |>
    rename(
      PSTR_risk_category = "risk_category",
      PSTR_share = "value",
      matching_certainty_company_average = "avg_matching_certainty",
      reduction_targets_avg = "profile_ranking_avg"
    )
}

relocate_sector_profile_company <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "PSTR_share", "PSTR_risk_category",
      "scenario", "year", "matching_certainty_company_average", "company_city", "postcode",
      "address", "main_activity"
    )
}
