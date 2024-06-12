#' Calculates best case and worst case for emission profile at product level
#'
#' @param data Dataframe. Emissions profile product level output
#'
#' @return A dataframe
#' @export
#' @keywords internal
#'
#' @examples
#' product <- unnest_product(toy_profile_emissions_impl_output())
#'
#' product |> best_case_worst_case_emission_profile()
best_case_worst_case_emission_profile <- function(data) {
  crucial_cols <- c(
    col_companies_id(), col_europages_product(),
    col_emission_grouped_by(), col_emission_profile()
  )
  check_crucial_cols(data, crucial_cols)

  best_case_worst_case_impl(data,
    col_risk = col_emission_profile(),
    col_group_by = col_emission_grouped_by()
  )
}
