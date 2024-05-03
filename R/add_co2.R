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
#' @family composable friends
#'
#' @return An object of the same class as `data`.
#' @export
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
  data_co2 <- data |> add_co2_footprint_and_co2_avg(co2)

  summary <- data_co2 |>
    unnest_product() |>
    summarize_co2_range_list() |>
    map(function(.x) jitter_co2_range(.x, amount = jitter_amount))
  product <- summary |>
    map(function(.x) join_to(.x, unnest_product(data_co2))) |>
    map(function(.x) polish_co2_range(.x,
      output_min_max = output_min_max,
      output_co2_footprint = output_co2_footprint
    )) |>
    reduce(bind_rows) |>
    filter(!is.na(.data[[col_min_jitter()]]) | !is.na(.data[[col_min_jitter()]]))

  company <- unnest_company(data_co2)

  tilt_profile(nest_levels(product, company))
}

add_co2_footprint_and_co2_avg <- function(data, co2) {
  co2 <- select(co2, matches(c(col_product_id(), col_footprint())))

  product <- data |>
    unnest_product() |>
    left_join(co2, by = col_product_id(), relationship = "many-to-many")

  by <- c(col_company_id(), col_grouped_by())
  footprint <- extract_name(co2, col_footprint())

  co2_avg <- product |>
    select(all_of(by), matches(col_footprint())) |>
    summarise(
      co2_avg = round(mean(.data[[footprint]], na.rm = TRUE), 3),
      .by = all_of(by)
    )

  company <- data |>
    unnest_company() |>
    left_join(co2_avg, by = by, relationship = "many-to-many")

  tilt_profile(nest_levels(product, company))
}
