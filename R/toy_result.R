#' Example datasets craeted from tiltToyData and tiltIndicator
#'
#' This datasets help to develop packages that are compatible with tiltToyData
#' and tiltIndicator.
#'
#' @return A dataframe that results from applying a function from tiltIndicator
#' with data from tiltToyData.
#'
#' @examples
#' # All datasets are momoised
#' system.time(toy_sector_profile_output())
#' system.time(toy_sector_profile_output())
#' @keywords internal
#' @name toy_output
NULL

toy_output <- memoise(function(fun, paths) {
  datasets <- lapply(paths, function(x) read_csv(x, show_col_types = FALSE))
  exec(fun, !!!datasets)
})

#' @export
#' @rdname toy_output
toy_emissions_profile_output <- function() {
  toy_output(
    emissions_profile,
    list(
      toy_emissions_profile_any_companies(),
      toy_emissions_profile_products()
    )
  )
}

#' @export
#' @rdname toy_output
toy_emissions_profile_upstream_output <- function() {
  toy_output(
    emissions_profile_upstream,
    list(
      toy_emissions_profile_any_companies(),
      toy_emissions_profile_upstream_products()
    )
  )
}

#' @export
#' @rdname toy_output
toy_sector_profile_output <- function() {
  toy_output(
    sector_profile,
    list(
      toy_sector_profile_companies(),
      toy_sector_profile_any_scenarios()
    )
  ) |>
    FIXME_mutate_product(isic_4digit = "1234")
}

#' @export
#' @rdname toy_output
toy_sector_profile_upstream_output <- function() {
  toy_output(
    sector_profile_upstream,
    list(
      toy_sector_profile_upstream_companies(),
      toy_sector_profile_any_scenarios(),
      toy_sector_profile_upstream_products()
    )
  ) |>
    FIXME_mutate_product(input_isic_4digit = "1234")
}

# isic_4digit: https://github.com/2DegreesInvesting/tiltToyData/issues/15
FIXME_mutate_product <- function(data, ...) {
  data |>
    mutate(product = lapply(product, \(x) mutate(x, ...)))
}
