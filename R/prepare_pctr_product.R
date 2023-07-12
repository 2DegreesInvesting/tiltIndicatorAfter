#' Creates final output of pctr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pctr_prod A dataframe like [pctr_product]
#' @param comp A dataframe like [ep_companies]
#'
#' @return A dataframe that prepares the final output of pctr_product
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' pctr_product <- pctr_product
#' ep_companies <- ep_companies
#'
#' pctr_product_final <- prepare_pctr_product(
#'   pctr_product,
#'   ep_companies,
#'   ecoinvent_activities,
#'   matches_mapper
#' )
#' pctr_product_final
prepare_pctr_product <- function(pctr_prod, comp, eco_activities, match_mapper) {
  result <- prepare_inter_pctr_product(pctr_prod, comp, eco_activities, match_mapper) |>
    relocate_pctr_product() |>
    rename_pctr_product() |>
    keep_first_row("PCTR_risk_category") |>
    mutate(benchmark = ifelse(is.na(.data$PCTR_risk_category), NA, .data$benchmark), .by = c("companies_id")) |>
    select(-c(
      "has_na", "row_number", "isic_4digit", "isic_4digit_name_ecoinvent",
      "isic_section", "matching_certainty_num", "avg_matching_certainty_num", "co2_footprint"
    )) |>
    distinct() |>
    arrange(.data$country)
}

rename_pctr_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      benchmark = "grouped_by",
      PCTR_risk_category = "risk_category",
      ep_product = "clustered"
    )
}

relocate_pctr_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "grouped_by",
      "clustered", "activity_name", "reference_product_name",
      "unit", "multi_match", "matching_certainty", "avg_matching_certainty",
      "co2_footprint", "company_city", "postcode", "address", "main_activity",
      "activity_uuid_product_uuid"
    )
}
