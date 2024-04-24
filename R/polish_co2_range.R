#' Polish the jittered range of CO2 values
#'
#' @param data A data frame.
#'
#' @keywords internal
#'
#' @return An object of the same class as `data`.
#' @export
#' @family composable friends
#' @family functions to handle CO2 range
#'
#' @examples
#' data <- tibble(min = 1, max = 2, min_jitter = 0, max_jitter = 4)
#'
#' data |> polish_co2_range()
polish_co2_range <- function(data) {
  data |>
    rename(co2_lower = "min_jitter", co2_upper = "max_jitter") |>
    select(-c("min", "max"))
}
