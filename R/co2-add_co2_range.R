#' Add a the jittered range of CO2 values
#'
#' This function is a shortcut for piping `data` into all other `*co2_range()`
#' functions, and then into [tiltIndicator::join_to()].
#'
#' @param data Depends on the class:
#' * `data.frame`: The `product` data frame of a `tilt_profile`.
#' * `tilt_profile`: `r document_tilt_profile()`.
#' @param ... Arguments passed to [tiltIndicator::jitter_range].
#' @param jitter_amount Numeric. Controls the amount of noise. Passed to
#'   `amount` in [tiltIndicator::jitter_range()].
#' @param output_min_max Logical. Output the columns `min` and `max`?
#'
#' @keywords internal
#'
#' @return An object of the same class as `data`.
#' @export
#' @family composable friends
#' @family functions to handle CO2 range
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
#' tilt_profile <- profile_emissions_impl(
#'   companies,
#'   co2,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' )
#'
#' tilt_profile |>
#'   unnest_product() |>
#'   add_co2_range()
#'
#' # Same
#' tilt_profile |>
#'   add_co2_range() |>
#'   unnest_product()
#'
#' # Cleanup
#' options(restore)
add_co2_range <- function(data, ...,
                          jitter_amount = option_jitter_amount(),
                          output_min_max = option_output_min_max()) {
  data |>
    summarize_co2_range() |>
    jitter_co2_range(amount = jitter_amount, ...) |>
    polish_co2_range(output_min_max = output_min_max) |>
    join_to(data)
}

add_co2 <- function(data, ...) UseMethod("add_co2")
add_co2.tilt_profile <- function(data, co2) {
  # TODO: Move to add_co2_range()
  out <- data |> add_co2_footprint_and_co2_avg(co2)

  out |>
    summarize_co2_range() |>
    jitter_co2_range(amount = option_jitter_amount()) |>
    # TODO: Create issue: Should default to TRUE instead? The package is not
    # useful for external users without a licence to co2_footprint
    polish_co2_range(
      output_min_max = option_output_min_max(),
      output_co2_footprint = option_output_co2_footprint()
    ) |>
    join_to(out)
}

add_co2_footprint_and_co2_avg <- function(data, co2) {
  co2 <- select(co2, matches(c("_uuid", "co2_footprint")))

  product <- data |>
    unnest_product() |>
    left_join(
      co2,
      by = "activity_uuid_product_uuid"
    )

  by <- c("companies_id", "benchmark")
  co2_avg <- product |>
    select(all_of(c(by, "co2_footprint"))) |>
    summarise(
      co2_avg = round(mean(co2_footprint, na.rm = TRUE), 3),
      .by = all_of(by)
    )
  company <- data |>
    unnest_company() |>
    left_join(co2_avg, by = by, relationship = "many-to-many")

  tilt_profile(nest_levels(product, company))
}
