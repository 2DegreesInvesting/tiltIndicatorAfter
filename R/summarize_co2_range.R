#' Summarize CO2 footprint
#'
#' @param data The output of [profile_emissions()] at product level but you can
#'   conveniently pipe the entire result "as is".
#' @param ... Arguments passed to [tiltIndicator::jitter_range].
#' @keywords internal
#'
#' @return A dataframe
#' @export
#' @family composable friends
#' @seealso [composable_friends]
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
#' # Works with the result of `emissions_profile()` --------------------------
#'
#' companies <- read_csv(toy_emissions_profile_any_companies())
#' co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
#' europages_companies <- read_csv(toy_europages_companies())
#' ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
#' ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
#' isic_name <- read_csv(toy_isic_name())
#'
#' result <- profile_emissions(
#'   companies,
#'   co2,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' )
#'
#' # It works with the product-level result
#' result |>
#'   unnest_product() |>
#'   summarize_co2_range()
#'
#' # But you can conveniently pipe profile result "as is"
#' result |>
#'   summarize_co2_range()
#'
#' # Cleanup
#' options(restore)
summarize_co2_range <- function(data) {
  UseMethod("summarize_co2_range")
}

#' @export
summarize_co2_range.data.frame <- function(data) {
  .benchmark <- "benchmark"
  .all <- c(.benchmark, "emission_profile")
  .by <- group_benchmark(unique(data[[.benchmark]]), .all)
  check_summarize_co2_range(data, benchmark_cols = unique(unlist(.by)))

  .x <- split(data, data[[.benchmark]])
  col <- extract_name(data, "co2_footprint")
  out <- summarize_range(.x, col = !!ensym(col), .by = .by)
  out <- reduce(out, bind_rows)
  out
}

#' @export
summarize_co2_range.tilt_profile <- function(data) {
  product <- unnest_product(data)
  summarize_co2_range(product)
}

check_summarize_co2_range <- function(data, benchmark_cols) {
  check_col(data, "benchmark")
  check_col(data, "co2_footprint")
  walk(benchmark_cols, function(pattern) check_matches_name(data, pattern))
}
