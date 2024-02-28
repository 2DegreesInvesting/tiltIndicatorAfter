#' Profile emissions and upstream emissions
#'
#' @inherit profile_sector_upstream
#' @inheritParams tiltIndicator::emissions_profile_upstream
#'
#' @family top-level functions
#'
#' @return `r document_default_value()`
#'
#' The columns `co2e_lower` and `co2e_upper` show the lowest and highest value
#' of `co2_footprint` within the group to which the product was compared, plus
#' some randomness. Therefore, every benchmark can have different `co2e_lower`
#' and `co2e_upper`, because every benchmark can contain a different set of
#' products.
#'
#' @export
#' @examples
#' library(tiltToyData)
#' library(readr, warn.conflicts = FALSE)
#'
#' options(readr.show_col_types = FALSE)
#'
#' companies <- read_csv(toy_emissions_profile_any_companies())
#' products <- read_csv(toy_emissions_profile_products_ecoinvent())
#' europages_companies <- read_csv(toy_europages_companies())
#' ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
#' ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
#' isic_name <- read_csv(toy_isic_name())
#'
#' result <- profile_emissions(
#'   companies,
#'   products,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' )
#'
#' result |> unnest_product()
#'
#' result |> unnest_company()
#'
#'
#'
#' inputs <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
#' ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
#'
#' result <- profile_emissions_upstream(
#'   companies,
#'   inputs,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_inputs = ecoinvent_inputs,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' )
#'
#' result |> unnest_product()
#'
#' result |> unnest_company()
profile_emissions_upstream <- function(companies,
                                       co2,
                                       europages_companies,
                                       ecoinvent_activities,
                                       ecoinvent_inputs,
                                       ecoinvent_europages,
                                       isic,
                                       isic_tilt = lifecycle::deprecated(),
                                       low_threshold = 1 / 3,
                                       high_threshold = 2 / 3) {
  if (lifecycle::is_present(isic_tilt)) {
    lifecycle::deprecate_warn(
      "0.0.0.9017",
      "profile_emissions_upstream(isic_tilt)",
      "profile_emissions_upstream(isic)"
    )
    isic <- isic_tilt
  }

  europages_companies <- select_europages_companies(europages_companies)
  ecoinvent_inputs <- select_ecoinvent_inputs(ecoinvent_inputs)

  indicator <- list(
    companies,
    add_rowid(co2),
    low_threshold,
    high_threshold
  )
  indicator_after <- list(
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs,
    isic
  )
  exec_profile("emissions_profile_upstream", indicator, indicator_after)
}
