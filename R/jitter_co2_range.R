#' Expand the range of CO2 values by adding some random noise
#'
#' This function expands a range by adding noise to the left of the minimum
#' values and to the right of the maximum values.
#'
#' @param data A data frame.
#' @param ... Arguments passed to [tiltIndicator::jitter_range()].
#'
#' @keywords internal
#'
#' @return A data frame.
#' @export
#' @family composable friends
#'
#' @examples
#' library(tibble)
#' library(withr)
#'
#' # styler: off
#' data <- tribble(
#'   ~benchmark, ~emission_profile, ~min, ~max, ~unit,
#'        "all",             "low",   1L,   2L,    NA,
#'       "unit",             "low",   3L,   4L,  "m2"
#' )
#' # styler: on
#'
#' local_seed(1)
#' data |> jitter_co2_range()
#'
#' local_seed(1)
#' data |> jitter_co2_range(amount = 20)
#'
#' # Same
#' local_seed(1)
#' # See `?tiltIndicatorAfter_options`
#' local_options(tiltIndicatorAfter.set_jitter_amount = 20)
#' data |> jitter_co2_range(amount = set_jitter_amount())
jitter_co2_range <- function(data, ...) {
  col <- "benchmark"

  data |>
    group_by(.data[[col]]) |>
    group_split() |>
    map(jitter_range, ...) |>
    reduce(bind_rows)
}
