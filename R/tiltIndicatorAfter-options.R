#' tiltIndicatorAfter options
#'
#' @description
#' These options are meant to be used mainly by developers or analysts while
#' testing the code or creating data:
#' * `tiltIndicatorAfter.set_jitter_amount`: Controls the amount of random noise
#' in the columns `co2*`.
#' * `tiltIndicatorAfter.output_co2_footprint_min_max`: Outputs the columns `min`
#' and `max` (calculated from `co2_footprint`), which yield the noisy `co2*`
#' columns.
#' * `tiltIndicatorAfter.output_co2_footprint`:
#'     * At product level it outputs licensed column `co2_footprint`.
#'     * At company level it outputs the column `co2_avg` (average `co2_footprint`
#'     by `companies_id`).
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
#' set.seed(1)
#'
#' restore <- withr::local_options(list(
#'   readr.show_col_types = FALSE,
#'   tiltIndicatorAfter.set_jitter_amount = 1,
#'   tiltIndicatorAfter.verbose = TRUE,
#'   tiltIndicatorAfter.output_co2_footprint_min_max = TRUE
#' ))
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
#' result |>
#'   unnest_product() |>
#'   select(matches(c("min", "max", "co2")))
#'
#' result |>
#'   unnest_company() |>
#'   select(matches(c("min", "max", "co2")))
NULL

set_jitter_amount <- function() {
  getOption("tiltIndicatorAfter.set_jitter_amount", default = 2)
}

output_co2_footprint_min_max <- function() {
  getOption("tiltIndicatorAfter.output_co2_footprint_min_max", default = FALSE)
}

output_co2_footprint <- function(options = NULL) {
  options$tiltIndicatorAfter.output_co2_footprint %||%
    getOption("tiltIndicatorAfter.output_co2_footprint", default = FALSE)
}

verbose <- function() {
  getOption("tiltIndicatorAfter.verbose", default = TRUE)
}
