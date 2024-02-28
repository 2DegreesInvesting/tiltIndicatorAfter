#' tiltIndicatorAfter options
#'
#' @description
#' Some behaviour can be controlled via an option. Typically these options are
#' used by developers or analysts who test the code or data before it's ready
#' for public consumption.
#'
#' * `tiltIndicatorAfter.co2_jitter_amount`: Controls the amount of random noise
#' in the `co2*` columns.
#' * `tiltIndicatorAfter.co2_keep_licensed_min_max`: Keeps the licensed `min`
#' and `max` columns that yield the noisy `co2*` columns.
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
#' amount <- 0.1
#' local_seed(1)
#' local_options(list(tiltIndicatorAfter.co2_jitter_amount = amount))
#' local_options(list(tiltIndicatorAfter.co2_keep_licensed_min_max = TRUE))
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
#' getOption("tiltIndicatorAfter.co2_jitter_amount")
#' mean(percent_noise(co2_cols$min, co2_cols$co2e_lower))
#' mean(percent_noise(co2_cols$max, co2_cols$co2e_upper))
#'
#'
#'
#' # Compare
#' amount <- 1
#' local_seed(1)
#' local_options(list(tiltIndicatorAfter.co2_jitter_amount = amount))
#' local_options(list(tiltIndicatorAfter.co2_keep_licensed_min_max = TRUE))
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
#' getOption("tiltIndicatorAfter.co2_jitter_amount")
#' mean(percent_noise(co2_cols$min, co2_cols$co2e_lower))
#' mean(percent_noise(co2_cols$max, co2_cols$co2e_upper))
NULL

co2_jitter_amount <- function() {
  getOption("tiltIndicatorAfter.co2_jitter_amount", default = 3)
}

co2_keep_licensed_min_max <- function() {
  getOption("tiltIndicatorAfter.co2_keep_licensed_min_max", default = FALSE)
}
