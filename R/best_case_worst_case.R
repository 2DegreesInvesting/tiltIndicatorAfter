#' Calculates Best case and Worst case for Emission profile at product level
#'
#' @param data Dataframe. Emissions profile product level output
#'
#' @return A dataframe
#' @export
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
#' profile_emissions_at_product_level <- profile_emissions(
#'   companies,
#'   co2,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' ) |>
#'   unnest_product()
#'
#' result <- best_case_worst_case(profile_emissions_at_product_level)
#' result
#'
#' # Cleanup
#' options(restore)
best_case_worst_case <- function(data) {
  crucial_cols <- c(col_companies_id(), col_ep_product(), col_benchmark(), col_emission_profile())
  check_matches_col_names(data, crucial_cols)

  data |>
    mutate(
      n_distinct_products = n_distinct(.data[[col_ep_product()]], na.rm = TRUE),
      .by = col_companies_id()
    ) |>
    mutate(
      equal_weight = ifelse(.data[[col_n_distinct_products()]] == 0, NA,
        1 / .data[[col_n_distinct_products()]]
      )
    ) |>
    lowest_risk_category_per_company_benchmark(.by = c(col_companies_id(), col_benchmark())) |>
    highest_risk_category_per_company_benchmark(.by = c(col_companies_id(), col_benchmark())) |>
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
      .by = c(col_companies_id(), col_benchmark())
    ) |>
    mutate(
      count_worst_case_products_per_company_benchmark = sum(.data[[col_worst_risk()]]),
      .by = c(col_companies_id(), col_benchmark())
    ) |>
    mutate(
      best_case = assign_case(
        .data, col_best_risk(),
        col_count_best_case_products_per_company_benchmark()
      )
    ) |>
    mutate(
      worst_case = assign_case(
        .data, col_worst_risk(),
        col_count_worst_case_products_per_company_benchmark()
      )
    )
}

lowest_risk_category_per_company_benchmark <- function(data, .by) {
  risk_order <- c("low", "medium", "high")
  mutate(data,
    min_risk_category_per_company_benchmark = risk_first_occurance(.data, risk_order),
    .by = all_of(.by)
  )
}

highest_risk_category_per_company_benchmark <- function(data, .by) {
  risk_order <- c("high", "medium", "low")
  mutate(data,
    max_risk_category_per_company_benchmark = risk_first_occurance(.data, risk_order),
    .by = all_of(.by)
  )
}

check_matches_col_names <- function(data, cols) {
  if (!any(cols %in% names(data))) {
    pattern <- cols[!(cols %in% names(data))]
    abort(c(
      glue("The data lacks column '{pattern}'."),
      i = "Are you using the correct data?"
    ), class = "check_matches_name")
  }
  invisible(data)
}

risk_first_occurance <- function(data, risk_order) {
  risk_order[which(risk_order %in% data[[col_emission_profile()]])[1]]
}

assign_risk <- function(data, emission_profile, risk_category_per_company_benchmark) {
  ifelse(is.na(data[[emission_profile]]), 0,
    ifelse(data[[emission_profile]] == data[[risk_category_per_company_benchmark]], 1, 0)
  )
}

assign_case <- function(data, risk, count_cases_products_per_company_benchmark) {
  ifelse(data[[count_cases_products_per_company_benchmark]] == 0, NA,
    data[[risk]] / data[[count_cases_products_per_company_benchmark]]
  )
}
