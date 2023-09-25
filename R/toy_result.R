#' Example datasets craeted from tiltToyData and tiltIndicator
#'
#' This datasets help to develop packages that are compatible with tiltToyData
#' and tiltIndicator.
#'
#' @return A dataframe that results from applying a function from tiltIndicator
#' with data from tiltToyData.
#'
#' @examples
#' toy_sector_profile_result()
#'
#' # All datasets are momoised
#' system.time(toy_sector_profile_upstream_result())
#' system.time(toy_sector_profile_upstream_result())
#' @keywords internal
#' @name toy_result
NULL

toy_result <- memoise(function(fun, paths) {
  datasets <- lapply(paths, function(x) read_csv(x, show_col_types = FALSE))
  exec(fun, !!!datasets)
})

#' @export
#' @rdname toy_result
toy_sector_profile_result <- function() {
  toy_result(
    sector_profile,
    list(
      toy_sector_profile_companies(),
      toy_sector_profile_any_scenarios()
    )
  )
}

#' @export
#' @rdname toy_result
toy_sector_profile_upstream_result <- function() {
  toy_result(
    sector_profile_upstream,
    list(
      toy_sector_profile_upstream_companies(),
      toy_sector_profile_any_scenarios(),
      toy_sector_profile_upstream_products()
    )
  )
}

#' @export
#' @rdname toy_result
toy_emissions_profile_upstream_result <- function() {
  toy_result(
    emissions_profile_upstream,
    list(
      toy_emissions_profile_any_companies(),
      toy_emissions_profile_upstream_products()
    )
  )
}
