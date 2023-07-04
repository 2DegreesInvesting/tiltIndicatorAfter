#' Creates final output of pctr company level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pctr_prod A dataframe like [pctr_product]
#' @param comp A dataframe like [companies]
#' @param pctr_comp A dataframe like [pctr_company]
#'
#' @return A dataframe that prepares the final output of pctr_company
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' pctr_product <- pctr_product
#' companies <- companies
#' pctr_company <- pctr_company
#'
#' pctr_company_final <- prepare_pctr_company(
#'   pctr_company,
#'   pctr_product,
#'   companies,
#'   ecoinvent_activities,
#'   matches_mapper
#' )
#'
#' pctr_company_final
prepare_pctr_company <- function(pctr_comp, pctr_prod, comp, eco_activities, match_mapper) {
  inter_result <- prepare_inter_pctr_product(pctr_prod, comp, eco_activities, match_mapper) |>
    select("companies_id", "company_name", "company_city", "country", "postcode", "address", "main_activity", "avg_matching_certainty") |>
    distinct()

  pctr_company_level <- pctr_comp |>
    left_join(inter_result, by = "companies_id") |>
    distinct() |>
    rename_pctr_company() |>
    keep_first_row("PCTR_share") |>
    mutate(
      PCTR_risk_category = ifelse(is.na(.data$matching_certainty_company_average), NA, .data$PCTR_risk_category),
      benchmark = ifelse(is.na(.data$matching_certainty_company_average), NA, .data$benchmark)
    ) |>
    relocate_pctr_company() |>
    select(-c("has_na", "row_number")) |>
    arrange(.data$companies_id)
}

rename_pctr_company <- function(data) {
  data |>
    rename(PCTR_risk_category = "risk_category",
           benchmark = "grouped_by",
           PCTR_share = "value",
           matching_certainty_company_average = "avg_matching_certainty"
    )
}

relocate_pctr_company <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "PCTR_share", "PCTR_risk_category",
      "benchmark", "matching_certainty_company_average", "company_city", "postcode",
      "address", "main_activity"
    )
}
