#' Summarize CO2 footprint
#'
#' @param data The output of `profile_emissions*()` at product level.
#' @param ... Arguments passed to [tiltIndicator::jitter_range].
#' @keywords internal
#'
#' @return A dataframe
#' @export
#'
#' @examples
#' # styler: off
#' data <- tibble::tribble(
#'   ~benchmark, ~emission_profile, ~co2_footprint, ~unit, ~tilt_sector, ~tilt_subsector, ~isic_4digit,
#'        "all",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
#'        "all",             "low",             2L,  "m2",    "sector1",    "subsector1",     "'1234'",
#'        "all",            "high",             3L,  "m2",    "sector1",    "subsector1",     "'1234'",
#'        "all",            "high",             4L,  "m2",    "sector1",    "subsector1",     "'1234'",
#'       "unit",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
#'       "unit",             "low",             2L,  "m2",    "sector1",    "subsector1",     "'1234'",
#'       "unit",            "high",             3L,  "m2",    "sector1",    "subsector1",     "'1234'",
#'       "unit",            "high",             4L,  "m2",    "sector1",    "subsector1",     "'1234'",
#' )
#' # styler: off
#'
#' data |>
#'   summarize_co2_range()
#'
#' withr::local_seed(1)
#' data |>
#'   summarize_co2_range() |>
#'   jitter_co2_range(amount = 1)
#'
#' withr::local_seed(1)
#' data |>
#'   summarize_co2_range() |>
#'   jitter_co2_range(amount = 1) |>
#'   polish_co2_range()
summarize_co2_range <- function(data) {
  is_profile_result <- function(data) {
    identical(names(data), c("companies_id", "product", "company"))
  }
  if (is_profile_result(data)) data <- unnest_product(data)



  .benchmark <- "benchmark"
  .all <- c(.benchmark, "emission_profile")
  .by <- group_benchmark(unique(data[[.benchmark]]), .all)

  check_summarize_co2_range(data, benchmark_cols = unique(unlist(.by)))

  .x <- split(data, data[[.benchmark]])
  col <- extract_name(data, "co2_footprint")
  out <- summarize_range(.x, col = !! ensym(col), .by = .by) |>
    suppressWarnings(classes = "passing_col_as_a_symbol_is_superseded")
  out <- reduce(out, bind_rows)
  out
}

check_summarize_co2_range <- function(data, benchmark_cols) {
  check_col(data, "benchmark")
  check_col(data, "co2_footprint")

  walk(benchmark_cols, function(pattern) check_matches_name(data, pattern))
}
