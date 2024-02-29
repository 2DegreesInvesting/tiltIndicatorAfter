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
#' local_options(readr.show_col_types = FALSE)
#'
#' companies <- read_csv(toy_emissions_profile_any_companies())
#' products <- read_csv(toy_emissions_profile_products_ecoinvent())
#' europages_companies <- read_csv(toy_europages_companies())
#' ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
#' ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
#' isic_name <- read_csv(toy_isic_name())
#'
#' # The example `co2_footprint` is hard to work with. It's small and widespread
#' products$co2_footprint
#'
#' # This makes it challenging to find the "right" jitter amount. So we need to
#' # be able to experiment with it.
#'
#' amount <- 0.1
#' # Ensure reproducible results
#' local_seed(1)
#' # Control percent noise
#' local_options(list(tiltIndicatorAfter.co2_jitter_amount = amount))
#'
#' # A message informs you the *mean* percent noise you achieved
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
#' amount <- 1
#' local_seed(1)
#' local_options(list(tiltIndicatorAfter.co2_jitter_amount = amount))
#' # Request the licensed `min` and `max` columns to explore the noise
#' local_options(list(tiltIndicatorAfter.co2_keep_licensed_min_max = TRUE))
#' # You may turn off the message informing the noise
#' local_options(list(tiltIndicatorAfter.verbose = FALSE))
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
