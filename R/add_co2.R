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

  product <- unnest_product(data_co2)
  .list <- summarize_co2_range_list(product)

  summary <- map(.list, function(.x) jitter_co2_range(.x, amount = jitter_amount))

  out_product <- summary |>
    map(~tiltIndicator:::join_to.data.frame(.x, product)) |>
    map(~polish_co2_range.data.frame(.x,
      output_min_max = output_min_max,
      output_co2_footprint = output_co2_footprint
    )) |>
    reduce(bind_rows) |>
    filter(
      !is.na(.data[[col_min_jitter()]]) |
      !is.na(.data[[col_min_jitter()]])
    )

  browser()
  company <- unnest_company(data_co2)

  tmp <- summary |>
    map(~tiltIndicator:::join_to.data.frame(.x, company))


    out_company <- tmp |>
    map(~polish_co2_range.data.frame(.x,
      output_min_max = output_min_max,
      output_co2_footprint = output_co2_footprint
    )) |>
    reduce(bind_rows) |>
    filter(
      !is.na(.data[[col_min_jitter()]]) |
      !is.na(.data[[col_min_jitter()]])
    )

  tilt_profile(nest_levels(out_product, out_company))


  # FIXME : delete?
  # match <- c(
  #   col_grouped_by(),
  #   pattern_risk_category_emissions_profile_any(),
  #   "min",
  #   "max"
  # )
  #
  # out <- data_co2 |>
  #   summarize_co2_range() |>
  #   # Remove columns that introduce NAs
  #   select(matches(match)) |>
  #   # FIXME: The select() above removes makes jitter_co2_range() work
  #   # beyond the limits of the required groupings. The fix may be to
  #   # move jitter_co2_range() to inside summarize_co2_range()?
  #   # Alternatively see if I can remove the call to select() in such a
  #   # wasy that I can still avoid undesireble NAs (are they really
  #   # undesirable?). OR, maybe I can work with the list-output of
  #   # summarize_range() so the jitter is applied to each split.
  #   jitter_co2_range(amount = jitter_amount) |>
  #   inform_noise_in_co2_range() |>
  #   join_to(data_co2) |>
  #   polish_co2_range(
  #     output_min_max = output_min_max,
  #     output_co2_footprint = output_co2_footprint
  #   )

  # out
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
