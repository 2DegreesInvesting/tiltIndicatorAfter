#' Calculates best case and worst case for emission profile at product level
#'
#' @param data Dataframe. Emissions profile product level output
#'
#' @return A dataframe
#' @export
#' @keywords internal
#'
#' @examples
#' library(tiltToyData)
#' library(readr)
#' restore <- options(readr.show_col_types = FALSE)
#'
#' companies <- read_csv(toy_emissions_profile_any_companies())
#' co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
#' europages_companies <- read_csv(toy_europages_companies())
#' ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
#' ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
#' isic_name <- read_csv(toy_isic_name())
#' profile_emissions_at_product_level <- profile_emissions_impl(
#'   companies,
#'   co2,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' ) |>
#'   unnest_product()
#'
#' result <- best_case_worst_case_emission_profile(profile_emissions_at_product_level)
#' result
#'
#' # Cleanup
#' options(restore)
best_case_worst_case_emission_profile <- function(data) {
  check_crucial_cols(data)

  data |>
    mutate(
      n_distinct_products = n_distinct(.data[[col_europages_product()]], na.rm = TRUE),
      .by = col_companies_id()
    ) |>
    mutate(
      equal_weight = ifelse(.data[[col_n_distinct_products()]] == 0, NA,
        1 / .data[[col_n_distinct_products()]]
      )
    ) |>
    get_min_risk_category_per_company_benchmark(.by = c(col_companies_id(), col_grouped_by())) |>
    get_max_risk_category_per_company_benchmark(.by = c(col_companies_id(), col_grouped_by())) |>
    mutate(
      best_risk = assign_risk(
        .data, col_emission_profile(),
        col_min_risk_category_per_company_benchmark()
      )
    ) |>
    mutate(
      worst_risk = assign_risk(
        .data, col_emission_profile(),
        col_max_risk_category_per_company_benchmark()
      )
    ) |>
    mutate(
      count_best_case_products_per_company_benchmark = sum(.data[[col_best_risk()]]),
      .by = c(col_companies_id(), col_grouped_by())
    ) |>
    mutate(
      count_worst_case_products_per_company_benchmark = sum(.data[[col_worst_risk()]]),
      .by = c(col_companies_id(), col_grouped_by())
    ) |>
    mutate(
      best_case = divide_risk_by_risk_counts(
        .data, col_best_risk(),
        col_count_best_case_products_per_company_benchmark()
      )
    ) |>
    mutate(
      worst_case = divide_risk_by_risk_counts(
        .data, col_worst_risk(),
        col_count_worst_case_products_per_company_benchmark()
      )
    )
}

get_min_risk_category_per_company_benchmark <- function(data, .by) {
  risk_order <- c("low", "medium", "high")
  mutate(data,
    min_risk_category_per_company_benchmark = risk_first_occurance(.data, risk_order),
    .by = all_of(.by)
  )
}

get_max_risk_category_per_company_benchmark <- function(data, .by) {
  risk_order <- c("high", "medium", "low")
  mutate(data,
    max_risk_category_per_company_benchmark = risk_first_occurance(.data, risk_order),
    .by = all_of(.by)
  )
}

risk_first_occurance <- function(data, risk_order) {
  risk_order[which(risk_order %in% data[[col_emission_profile()]])[1]]
}

assign_risk <- function(data, emission_profile, risk_category_per_company_benchmark) {
  ifelse(is.na(data[[emission_profile]]), 0,
    ifelse(data[[emission_profile]] == data[[risk_category_per_company_benchmark]], 1, 0)
  )
}

divide_risk_by_risk_counts <- function(data, risk, count_risk_cases_per_company_benchmark) {
  ifelse(data[[count_risk_cases_per_company_benchmark]] == 0, NA,
    data[[risk]] / data[[count_risk_cases_per_company_benchmark]]
  )
}

check_crucial_cols <- function(data) {
  crucial_cols <- c(col_companies_id(), col_europages_product(), col_grouped_by(), col_emission_profile())
  walk(crucial_cols, ~ check_matches_name(data, .x))
}
