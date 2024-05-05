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
#' co2 <- readr::read_csv(tiltToyData::toy_emissions_profile_products_ecoinvent())
#'
#' toy_profile_emissions_impl_output() |>
#'   add_co2(co2)
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
  data_co2 <- data |>
    add_co2_footprint(co2) |>
    add_co2_avg()

  product <- data_co2 |>
    unnest_product() |>
    summarize_co2_range_list() |>
    map(\(.x) jitter_co2_range(.x, amount = jitter_amount)) |>
    map(\(.x) join_to(.x, unnest_product(data_co2))) |>
    reduce(bind_rows) |>
    polish_co2_range(
      output_min_max = output_min_max,
      output_co2_footprint = output_co2_footprint
    ) |>
    filter(!is.na(.data[[col_min_jitter()]]) | !is.na(.data[[col_min_jitter()]]))

  company <- unnest_company(data_co2)

  tilt_profile(nest_levels(product, company))
}

add_co2_footprint <- function(data, co2) {
  product <- data |>
    unnest_product() |>
    left_join(
      co2 |> select_product_id_and_footprint(),
      by = col_product_id(),
      relationship = "many-to-many"
    )
  company <- data |>
    unnest_company()

  tilt_profile(nest_levels(product, company))
}

select_product_id_and_footprint <- function(data) {
  select(data, matches(c(col_product_id(), col_footprint())))
}

add_co2_avg <- function(data) {
  product <- data |>
    unnest_product()

  by <- c(col_company_id(), col_grouped_by())
  footprint <- extract_name(product, col_footprint())

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
