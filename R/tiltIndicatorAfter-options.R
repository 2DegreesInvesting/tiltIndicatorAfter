#' tiltIndicatorAfter options
#'
#' @description
#' These options are meant to be used mainly by developers or analysts while
#' testing the code or creating data:
#' * `tiltIndicatorAfter.co2_jitter_amount`: Controls the amount of random noise
#' in the `co2*` columns.
#' * `tiltIndicatorAfter.co2_keep_licensed_min_max`: Keeps the licensed `min`
#' and `max` columns that yield the noisy `co2*` columns.
#' * `tiltIndicatorAfter.verbose`: Controls verbosity.
#'
#' @keywords internal
#' @name tiltIndicatorAfter_options
#'
#' @examples
#' library(readr, warn.conflicts = FALSE)
#' library(dplyr, warn.conflicts = FALSE)
#' library(withr)
#' library(tiltToyData)
#' library(tiltIndicator)
#'
#' companies <- read_csv(toy_emissions_profile_any_companies())
#' products <- read_csv(toy_emissions_profile_products_ecoinvent())
#' europages_companies <- read_csv(toy_europages_companies())
#' ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
#' ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
#' isic_name <- read_csv(toy_isic_name())
#'
#' set.seed(1)
#' restore <- options(list(
#'   tiltIndicatorAfter.co2_jitter_amount = 0.1,
#'   tiltIndicatorAfter.co2_keep_licensed_min_max = FALSE,
#'   tiltIndicatorAfter.verbose = TRUE
#' ))
#' on.exit(options(restore), add = TRUE, after = FALSE)
#'
#' co2_cols <- profile_emissions(
#'   companies,
#'   products,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' )
#'
#' # Compare
#'
#' set.seed(1)
#' restore <- options(list(
#'   tiltIndicatorAfter.co2_jitter_amount = 1,
#'   tiltIndicatorAfter.co2_keep_licensed_min_max = TRUE,
#'   tiltIndicatorAfter.verbose = FALSE
#' ))
#'
#' co2_cols <- profile_emissions(
#'   companies,
#'   products,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' ) |>
#'   unnest_product() |>
#'   select(matches(c("min", "max", "co2")))
#'
#' mean(percent_noise(co2_cols$min, co2_cols$co2e_lower))
#' mean(percent_noise(co2_cols$max, co2_cols$co2e_upper))
#'
#' options(restore)
NULL

co2_jitter_amount <- function() {
  getOption("tiltIndicatorAfter.co2_jitter_amount", default = 2)
}

co2_keep_licensed_min_max <- function() {
  getOption("tiltIndicatorAfter.co2_keep_licensed_min_max", default = FALSE)
}

verbose <- function() {
  getOption("tiltIndicatorAfter.verbose", default = TRUE)
}
