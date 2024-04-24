#' Add a jittered range of CO2
#'
#' `add_co2_range()` is a shortcut for all other `*co2_range()` functions.
#'
#' @param data The output of [profile_emissions()] at product level but you can
#'   conveniently pipe the entire result "as is".
#' @param ... Arguments passed to [tiltIndicator::jitter_range].
#' @keywords internal
#'
#' @return A dataframe
#' @export
#' @family composable friends
#'
#' @examples
#' library(readr, warn.conflicts = FALSE)
#' library(tiltToyData)
#'
#' restore <- options(list(
#'   readr.show_col_types = FALSE,
#'   tiltIndicatorAfter.output_co2_footprint = TRUE
#' ))
#'
#' companies <- read_csv(toy_emissions_profile_any_companies())
#' co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
#' europages_companies <- read_csv(toy_europages_companies())
#' ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
#' ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
#' isic_name <- read_csv(toy_isic_name())
#'
#' out <- profile_emissions_impl(
#'   companies,
#'   co2,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' ) |>
#' add_co2_range()
#'
#' out |> unnest_product() |> relocate(matches("co2"))
#'
#' out |> unnest_company() |> relocate(matches("co2"))
#'
#' # Cleanup
#' options(restore)
add_co2_range <- function(data, ...) {
  data |>
    summarize_co2_range() |>
    jitter_co2_range(...) |>
    polish_co2_range() |>
    join_to(data)
}
