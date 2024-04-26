#' Polish the jittered range of CO2 values
#'
#' @param data A data frame.
#' @param ... Unused but necessary for compatibility across methods.
#'
#' @keywords internal
#'
#' @return An object of the same class as `data`.
#' @export
#' @family composable friends
#' @family functions to handle CO2 range
#'
#' @examples
#' library(tibble)
#'
#' data <- tibble(min = 1, max = 2, min_jitter = 0, max_jitter = 4)
#'
#' data |> polish_co2_range()
#'
#' data |> polish_co2_range(output_min_max = TRUE)
polish_co2_range <- function(data, ...) {
  UseMethod("polish_co2_range")
}

#' @export
polish_co2_range.data.frame <- function(data,
                                        ...,
                                        output_min_max = FALSE,
                                        output_co2_footprint = FALSE) {
  out <- data |> rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter")

  if (!output_min_max) {
    out <- out |> exclude(c("^min$", "^max$"))
  }

  if (!output_co2_footprint) {
    out <- out |> exclude("co2_footprint")
  }

  out |> relocate(matches("co2e"), .after = matches("benchmark"))
}

#' @export
polish_co2_range.tilt_profile <- function(data,
                                          ...,
                                          output_min_max = FALSE,
                                          output_co2_footprint = FALSE) {
  product <- data |>
    unnest_product() |>
    polish_co2_range(
      output_min_max = output_min_max,
      output_co2_footprint = output_co2_footprint
    )

  company <- data |>
    unnest_company() |>
    polish_co2_range(
      output_min_max = output_min_max,
      output_co2_footprint = output_co2_footprint
    )

  tilt_profile(nest_levels(product, company))
}
