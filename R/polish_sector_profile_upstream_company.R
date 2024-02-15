#' Creates final output of Sector Profile Upstream company level results
#'
#' @return A dataframe
#'
#' @keywords internal
#' @examples
#' # See examples in `?profile_sector_upstream`
polish_sector_profile_upstream_company <- function(spu_comp, spu_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, ecoinvent_inputs, isic) {
  spu_prod <- sanitize_isic(spu_prod)
  spu_comp <- sector_profile_any_polish_output_at_company_level(spu_comp)

  inter_result <- polish_sector_profile_upstream_product(spu_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, ecoinvent_inputs, isic) |>
    select(
      "companies_id", "company_name", "company_city", "country", "postcode",
      "address", "main_activity", "matching_certainty_company_average"
    ) |>
    distinct()

  spu_comp |>
    left_join(inter_result, by = "companies_id") |>
    rename_sector_profile_upstream_company() |>
    mutate(scenario = recode(.data$scenario, "1.5c rps" = "IPR 1.5c RPS", "nz 2050" = "WEO NZ 2050")) |>
    exclude_rows("ISTR_share") |>
    select(-c("type")) |>
    relocate_sector_profile_upstream_company() |>
    arrange(.data$companies_id) |>
    distinct() |>
    rename_118()
}

rename_sector_profile_upstream_company <- function(data) {
  data |>
    rename(
      ISTR_risk_category = "risk_category",
      ISTR_share = "value"
    )
}

relocate_sector_profile_upstream_company <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "ISTR_share",
      "ISTR_risk_category", "scenario", "year", "matching_certainty_company_average",
      "company_city", "postcode", "address", "main_activity"
    )
}
