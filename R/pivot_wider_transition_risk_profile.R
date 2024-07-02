#' Calculate the indicator "transition risk profile"
#'
#' @param pivot_wider Logical. Pivot the output at company level to a wide
#'   format?
#'
#' @return `r document_tilt_profile()`
#' @export
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' library(readr, warn.conflicts = FALSE)
#' library(dplyr, warn.conflicts = FALSE)
#' library(tiltToyData, warn.conflicts = FALSE)
#' library(tiltTransitionRisk, warn.conflicts = FALSE)
#'
#' restore <- options(list(
#'   readr.show_col_types = FALSE,
#'   tiltIndicatorAfter.output_co2_footprint = TRUE
#' ))
#'
#' toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
#' toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
#' toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
#' toy_sector_profile_companies <- read_csv(toy_sector_profile_companies())
#' toy_europages_companies <- read_csv(toy_europages_companies())
#' toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
#' toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
#' toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
#' toy_isic_name <- read_csv(toy_isic_name())
#' toy_all_activities_scenario_sectors <- read_csv(toy_all_activities_scenario_sectors())
#'
#' toy_emissions_profile <- profile_emissions(
#'   companies = toy_emissions_profile_any_companies,
#'   co2 = toy_emissions_profile_products_ecoinvent,
#'   europages_companies = toy_europages_companies,
#'   ecoinvent_activities = toy_ecoinvent_activities,
#'   ecoinvent_europages = toy_ecoinvent_europages,
#'   isic = toy_isic_name
#' )
#'
#' toy_sector_profile <- profile_sector(
#'   companies = toy_sector_profile_companies,
#'   scenarios = toy_sector_profile_any_scenarios,
#'   europages_companies = toy_europages_companies,
#'   ecoinvent_activities = toy_ecoinvent_activities,
#'   ecoinvent_europages = toy_ecoinvent_europages,
#'   isic = toy_isic_name
#' )
#'
#' # Most banks need company-level results in long format
#' pivot_wider <- FALSE
#'
#' long <- transition_risk_profile_impl(
#'   emissions_profile,
#'   sector_profile,
#'   co2,
#'   all_activities_scenario_sectors,
#'   scenarios,
#'   exclude_co2 = pivot_wider
#' ) |>
#'   add_transition_risk_category_at_company_level() |>
#'   best_case_worst_case_transition_risk_profile_at_company_level() |>
#'   pivot_wider_transition_risk_profile(pivot_wider = pivot_wider) |>
#'   unnest_company()
#' long
#'
#' # Some banks need company-level results in wide format
#' pivot_wider <- TRUE
#'
#' wide <- transition_risk_profile_impl(
#'   emissions_profile,
#'   sector_profile,
#'   co2,
#'   all_activities_scenario_sectors,
#'   scenarios,
#'   exclude_co2 = pivot_wider
#' ) |>
#'   add_transition_risk_category_at_company_level() |>
#'   best_case_worst_case_transition_risk_profile_at_company_level() |>
#'   pivot_wider_transition_risk_profile(pivot_wider = pivot_wider) |>
#'   unnest_company()
#' wide
#'
#' # Cleanup
#' options(restore)
#' }
pivot_wider_transition_risk_profile <- function(data, pivot_wider = FALSE) {
  product <- data |>
    unnest_product()

  company <- data |>
    unnest_company()

  if (pivot_wider) {
    emission_profile_company <- company |>
      select_emissions_profile_pivot_cols() |>
      exclude_cols_then_pivot_wider(
        exclude_cols = "co2e",
        avoid_list_cols = TRUE,
        id_cols = c(
          "companies_id",
          "country",
          "main_activity",
          "benchmark",
          "profile_ranking_avg"
        ),
        names_from = "emission_profile",
        names_prefix = "emission_category_",
        values_from = "emission_profile_share"
      )

    sector_profile_company <- company |>
      select_sector_profile_pivot_cols() |>
      exclude_cols_then_pivot_wider(
        exclude_cols = "co2e",
        avoid_list_cols = TRUE,
        id_cols = c(
          "companies_id",
          "country",
          "main_activity",
          "scenario",
          "year",
          "reduction_targets_avg"
        ),
        names_from = "sector_profile",
        names_prefix = "sector_category_",
        values_from = "sector_profile_share"
      )

    transition_risk_profile_company <- company |>
      select_transition_risk_profile_pivot_cols() |>
      exclude_cols_then_pivot_wider(
        exclude_cols = "co2e",
        avoid_list_cols = TRUE,
        id_cols = c(
          "companies_id",
          "country",
          "main_activity",
          "benchmark_tr_score_avg",
          "avg_transition_risk_equal_weight",
          "avg_transition_risk_best_case",
          "avg_transition_risk_worst_case"
        ),
        names_from = "transition_risk_category",
        names_prefix = "transition_risk_category_",
        values_from = "transition_risk_category_share"
      )

    company <- full_join(emission_profile_company,
      sector_profile_company,
      by = c(
        "companies_id",
        "country",
        "main_activity"
      )
    ) |>
      unite("benchmark_tr_score_avg", all_of(benchmark_cols()), remove = FALSE) |>
      full_join(transition_risk_profile_company,
        by = c(
          "companies_id",
          "country",
          "main_activity",
          "benchmark_tr_score_avg"
        )
      )
  }

  tilt_profile(nest_levels(product, company))
}

select_emissions_profile_pivot_cols <- function(data) {
  select(data, c(
    "companies_id",
    "country",
    "main_activity",
    "benchmark",
    "profile_ranking_avg",
    "emission_profile",
    "emission_profile_share"
  ))
}

select_sector_profile_pivot_cols <- function(data) {
  select(data, c(
    "companies_id",
    "country",
    "main_activity",
    "scenario",
    "year",
    "reduction_targets_avg",
    "sector_profile",
    "sector_profile_share"
  ))
}

select_transition_risk_profile_pivot_cols <- function(data) {
  select(data, c(
    "companies_id",
    "country",
    "main_activity",
    "benchmark_tr_score_avg",
    "avg_transition_risk_equal_weight",
    "transition_risk_category",
    "transition_risk_category_share",
    "avg_transition_risk_best_case",
    "avg_transition_risk_worst_case"
  ))
}
