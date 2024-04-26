#' Summarize the range of CO2 values
#'
#' @param data Depends on the class:
#' * `data.frame`: The `product` data frame of a `tilt_profile`.
#' * `tilt_profile`: `r document_tilt_profile()`.
#'
#' @keywords internal
#'
#' @return A data frame.
#' @export
#' @family composable friends
#' @family functions to handle CO2 range
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' library(tidyr, warn.conflicts = FALSE)
#'
#' x <- tidyr::expand_grid(
#'   benchmark = c("all", "unit", "tilt_sector", "unit_tilt_sector"),
#'   emission_profile = c("low", "medium", "high"),
#'   unit = c("m2", "kg"),
#'   tilt_sector = c("sector1", "sector2"),
#'   tilt_subsector = c("subsector1", "subsector2"),
#' )
#' y <- tibble(
#'   emission_profile = c("low", "medium", "high"),
#'   isic_4digit = "'1234'",
#'   co2_footprint = 1:3,
#' )
#' data <- left_join(x, y, by = "emission_profile", relationship = "many-to-many")
#' data |>
#'   print(n = Inf)
#'
#' data |>
#'   summarize_co2_range() |>
#'   print(n = Inf)
summarize_co2_range <- function(data) {
  UseMethod("summarize_co2_range")
}

#' @export
summarize_co2_range.data.frame <- function(data) {
  .benchmark <- "benchmark"
  .emission_profile <- extract_name(data, "emission_.*profile$")
  .all <- c(.benchmark, .emission_profile)
  # `split()` drops `NA`s in `.x`, so it makes sense to also drop them in `.by`
  .by <- group_benchmark(unique(data[[.benchmark]]), .all, na.rm = TRUE)

  check_summarize_co2_range(data, benchmark_cols = unique(unlist(.by)))

  .x <- split(data, data[[.benchmark]])
  col <- extract_name(data, "co2_footprint")
  out <- summarize_range(.x, col = !!ensym(col), .by = .by)
  out <- reduce(out, bind_rows)
  out
}

#' @export
summarize_co2_range.tilt_profile <- function(data) {
  data |>
    unnest_product() |>
    summarize_co2_range()
}

check_summarize_co2_range <- function(data, benchmark_cols) {
  c(col_benchmark(), col_footprint(), pattern_emission_profile(), benchmark_cols) |>
    walk(function(pattern) check_matches_name(data, pattern))

  if (all(is.na(data[[col_benchmark()]]))) {
    msg <- glue("Can't handle data where all `{col_benchmark()}` is `NA`.")
    abort(msg, class = "all_benchmark_is_na")
  }

  invisible(data)
}
