#' Example sector profile result
#'
#' @return A dataframe like the output of [tiltIndicator::sector_profile()].
#' @export
#'
#' @examples
#' sector_profile_result()
#' @keywords internal
sector_profile_result <- memoise(function() {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  sector_profile(companies, scenarios)
})
