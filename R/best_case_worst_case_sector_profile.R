#' Calculates best case and worst case for sector profile at product level
#'
#' @param data Dataframe. Sector profile nested output
#'
#' @return A dataframe
#' @export
#' @keywords internal
#'
#' @examples
#' out <- toy_profile_sector_impl_output()
#'
#' out |> best_case_worst_case_sector_profile()
best_case_worst_case_sector_profile <- function(data) {
  crucial_cols <- c(
    col_companies_id(), col_europages_product(),
    "scenario", "year", "sector_profile"
  )

  product <- data |>
    unnest_product()

  check_crucial_cols(product, crucial_cols)

  product <- product |>
    add_scenario_year() |>
    best_case_worst_case_impl(
      col_group_by = "scenario_year",
      col_risk = "sector_profile",
      col_rank = "reduction_targets"
    ) |>
    polish_best_case_worst_case() |>
    polish_best_case_worst_case_sector_profile() |>
    select(-all_of(c("scenario_year")))

  company <- data |>
    unnest_company()

  tilt_profile(nest_levels(product, company))
}

add_scenario_year <- function(data) {
  mutate(data, scenario_year = ifelse(
    is.na(.data$reduction_targets),
    NA_character_,
    paste(.data$scenario, .data$year, sep = "_")
  ))
}
