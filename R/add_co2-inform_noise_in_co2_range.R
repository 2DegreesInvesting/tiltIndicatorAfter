#' Inform the noise in the jittered CO2 range
#'
#' @param data A data frame.
#'
#' @return Called for its side effect. Returns invisible `data`.
#' @export
#' @keywords internal
#' @family composable friends
#'
#' @examples
#' library(tibble)
#'
#' min <- 1:3
#' max <- 4:6
#' # Add 10% noise
#' min_jitter <- -min * 1.1
#' # Add 50% noise
#' max_jitter <- max * 1.5
#' data <- tibble(min_jitter, min, max, max_jitter)
#'
#' inform_noise_in_co2_range(data)
inform_noise_in_co2_range <- function(data) {
  if (!option_verbose()) {
    return(invisible(data))
  }

  l <- round(mean(percent_noise(data$min, data$min_jitter), na.rm = TRUE))
  u <- round(mean(percent_noise(data$max, data$max_jitter), na.rm = TRUE))
  inform(c(i = glue(
    "Adding {l}% and {u}% noise to `{col_min_jitter()}` and `{col_max_jitter()}`, respectively."
  )))

  invisible(data)
}
