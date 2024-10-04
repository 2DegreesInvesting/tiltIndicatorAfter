#' Calculates best case and worst case for emission profile at product level
#'
#' @param data Dataframe. Emissions profile nested output
#'
#' @return A dataframe
#' @export
#' @keywords internal
#'
#' @examples
#' out <- toy_profile_emissions_impl_output()
#'
#' out |> best_case_worst_case_emission_profile()
best_case_worst_case_emission_profile <- function(data) {
  crucial_cols <- c(
    col_companies_id(), col_europages_product(),
    col_emission_grouped_by(), col_emission_profile()
  )

  product <- data |>
    unnest_product()

  check_crucial_cols(product, crucial_cols)

  product <- product |>
    best_case_worst_case_impl(
      col_group_by = col_emission_grouped_by(),
      col_risk = col_emission_profile(),
      col_rank = "profile_ranking"
    ) |>
    polish_best_case_worst_case() |>
    polish_best_case_worst_case_emissions_profile()

  company <- data |>
    unnest_company()

  tilt_profile(nest_levels(product, company))
}
