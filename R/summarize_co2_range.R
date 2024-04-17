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
#'   summarize_co2_range() |>
#'   jitter_co2_range(amount = 1) |>
#'   polish_co2_range()
summarize_co2_range <- function(data) {
  .benchmark <- "benchmark"
  .all <- c(.benchmark, "emission_profile")

  .x <- split(data, data[[.benchmark]])
  col <- extract_name(data, "co2_footprint")
  .by <- group_benchmark(unique(data[[.benchmark]]), .all)

  out <- map_summarize_range(.x, col = col, .by = .by)
  reduce(out, bind_rows)
}

#' @export
#' @rdname summarize_co2_range
jitter_co2_range <- function(data, ...) {
  data |>
    group_by(data$benchmark) |>
    group_split() |>
    map(jitter_range, ...) |>
    reduce(bind_rows)
}

#' @export
#' @rdname summarize_co2_range
polish_co2_range <- function(data) {
  data |>
    rename(co2_lower = "min_jitter", co2_upper = "max_jitter") |>
    select(-c("min", "max"))
}
