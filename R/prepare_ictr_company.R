#' Creates final output of ictr company level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param ictr_prod A dataframe like [ictr_product]
#' @param comp A dataframe like [companies]
#' @param ictr_comp A dataframe like [ictr_company]
#' @param eco_inputs A dataframe like [ecoinvent_inputs]
#'
#' @return A dataframe that prepares the final output of ictr_company
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' ictr_product <- ictr_product
#' companies <- companies
#' ictr_company <- ictr_company
#' ecoinvent_inputs <- ecoinvent_inputs
#'
#' ictr_company_final <- prepare_ictr_company(
#'   ictr_company,
#'   ictr_product,
#'   companies,
#'   ecoinvent_activities,
#'   matches_mapper,
#'   ecoinvent_inputs
#' )
#'
#' ictr_company_final
prepare_ictr_company <- function(ictr_comp, ictr_prod, comp, eco_activities, match_mapper, eco_inputs) {

  inter_result <- prepare_ictr_product(ictr_prod, comp, eco_activities, match_mapper, eco_inputs) |>
    select("companies_id", "company_name", "company_city", "country", "postcode",
           "address", "main_activity", "matching_certainty_company_average") |>
    distinct()

  ictr_company_level <- ictr_comp |>
    left_join(inter_result, by = "companies_id") |>
    distinct() |>
    rename_ictr_company() |>
    keep_first_row("ICTR_share") |>
    # Error: here is ICTR_share used instead of matching_certainty_company_average
    mutate(benchmark = ifelse(is.na(.data$ICTR_share), NA, benchmark)) |>
    mutate(ICTR_risk_category = ifelse(is.na(.data$ICTR_share), NA, ICTR_risk_category)) |>
    relocate(
      "companies_id", "company_name", "company_city", "country", "ICTR_share",
      "ICTR_risk_category", "benchmark", "matching_certainty_company_average",
      "postcode", "address", "main_activity"
    ) |>
    select(-c("has_na", "row_number")) |>
    arrange(companies_id)
}

rename_ictr_company <- function(data) {
  data |>
    rename(
      ICTR_risk_category = "risk_category",
      benchmark = "grouped_by",
      ICTR_share = "value"
    )
}
