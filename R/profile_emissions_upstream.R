#' Profile emissions and upstream emissions
#'
#' These functions wrap the output of the corresponding function in
#' [tiltIndicator](https://2degreesinvesting.github.io/tiltIndicator/reference/index.html).
#'
#' @inheritParams tiltIndicator::emissions_profile_upstream
#' @param europages_companies Dataframe. Companies from europages.
#' @param ecoinvent_activities Dataframe. Activities from ecoinvent.
#' @param ecoinvent_inputs Dataframe. Upstream products from ecoinvent.
#' @param ecoinvent_europages Dataframe. Mapper between europages and ecoinvent.
#' @param isic Dataframe. ISIC data.
#' @param isic_tilt `r lifecycle::badge("deprecated")`
#'
#' @return `r document_default_value()`
#' @export
#'
#' @family top-level functions
#'
#' @examples
#' library(tiltToyData)
#' library(readr, warn.conflicts = FALSE)
#'
#' options(readr.show_col_types = FALSE)
#'
#' companies <- read_csv(toy_emissions_profile_any_companies())
#' products <- read_csv(toy_emissions_profile_products())
#'
#' result <- profile_emissions(
#'   companies,
#'   products,
#'   # TODO: Move to tiltToyData
#'   europages_companies = tiltIndicatorAfter::ep_companies,
#'   ecoinvent_activities = tiltIndicatorAfter::ecoinvent_activities,
#'   ecoinvent_europages = tiltIndicatorAfter::matches_mapper |> head(100),
#'   isic = tiltIndicatorAfter::isic
#' )
#'
#' result |> unnest_product()
#'
#' result |> unnest_company()
#'
#'
#'
#' inputs <- read_csv(toy_emissions_profile_upstream_products())
#'
#' result <- profile_emissions_upstream(
#'   companies,
#'   inputs,
#'   # TODO: Move to tiltToyData
#'   europages_companies = tiltIndicatorAfter::ep_companies,
#'   ecoinvent_activities = tiltIndicatorAfter::ecoinvent_activities,
#'   ecoinvent_inputs = tiltIndicatorAfter::ecoinvent_inputs,
#'   ecoinvent_europages = tiltIndicatorAfter::matches_mapper |> head(100),
#'   isic = tiltIndicatorAfter::isic
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
