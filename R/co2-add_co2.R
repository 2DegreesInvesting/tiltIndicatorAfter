#' Add a the jittered range of CO2 values
#'
#' @inheritParams profile_emissions
#' @param ... Unused but necessary for compatibility across methods.
#' @param jitter_amount Numeric. Controls the amount of noise. Passed to
#'   `amount` in [tiltIndicator::jitter_range()].
#' @param output_min_max Logical. Output the columns `min` and `max`?
#' @param output_co2_footprint Logical. Output the columns `co2_footprint` (at
#'   product and company levels) and `co2_avg` (at company level only)?
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
#' tilt_profile |> add_co2(co2)
#'
#' # Cleanup
#' options(restore)
add_co2 <- function(data, co2, ...) {
  UseMethod("add_co2")
}

#' @rdname add_co2
#' @export
add_co2.tilt_profile <- function(data,
                                 co2,
                                 ...,
                                 jitter_amount = option_jitter_amount(),
                                 output_min_max = option_output_min_max(),
                                 output_co2_footprint = option_output_co2_footprint()) {
  out <- data |> add_co2_footprint_and_co2_avg(co2)

  out |>
    summarize_co2_range() |>
    jitter_co2_range(amount = jitter_amount) |>
    inform_noise_in_co2_range() |>
    join_to(out) |>
    polish_co2_range(
      output_min_max = output_min_max,
      # TODO open issue: Should always be TRUE? Not useful without a license
      output_co2_footprint = output_co2_footprint
    )
}

add_co2_footprint_and_co2_avg <- function(data, co2) {
  co2 <- select(co2, matches(c("_uuid", "co2_footprint")))

  product <- data |>
    unnest_product() |>
    left_join(
      co2,
      by = "activity_uuid_product_uuid",
      relationship = "many-to-many"
    )

  by <- c("companies_id", "benchmark")
  footprint_col <- extract_name(co2, "co2_footprint$")

  co2_avg <- product |>
    select(all_of(by), matches("co2_footprint")) |>
    summarise(
      co2_avg = round(mean(.data[[footprint_col]], na.rm = TRUE), 3),
      .by = all_of(by)
    )

  company <- data |>
    unnest_company() |>
    left_join(co2_avg, by = by, relationship = "many-to-many")

  tilt_profile(nest_levels(product, company))
}
