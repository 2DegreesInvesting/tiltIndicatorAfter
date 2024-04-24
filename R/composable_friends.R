#' Composable friends
#'
#' These functions are designed to work well together. Each does something
#' small. Compose them to create complex results.
#'
#' @name composable_friends
#' @examples
#' library(readr, warn.conflicts = FALSE)
#' library(dplyr, warn.conflicts = FALSE)
#' library(tiltToyData)
#' library(tiltIndicator)
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
#'
#' emissions_profile <- profile_emissions_impl(
#'   companies = toy_emissions_profile_any_companies,
#'   co2 = toy_emissions_profile_products_ecoinvent,
#'   europages_companies = toy_europages_companies,
#'   ecoinvent_activities = toy_ecoinvent_activities,
#'   ecoinvent_europages = toy_ecoinvent_europages,
#'   isic = toy_isic_name
#' ) |>
#'   add_co2_range()
#'   # TODO: Add `co2_avg`
#'
#' sector_profile <- profile_sector(
#'   companies = toy_sector_profile_companies,
#'   scenarios = toy_sector_profile_any_scenarios,
#'   europages_companies = toy_europages_companies,
#'   ecoinvent_activities = toy_ecoinvent_activities,
#'   ecoinvent_europages = toy_ecoinvent_europages,
#'   isic = toy_isic_name
#' )
#'
#' # TODO: Use the class 'tilt_profile'?
#' result <- score_transition_risk_and_polish(emissions_profile, sector_profile)
#' result
#'
#' # Cleanup
#' options(restore)
NULL
