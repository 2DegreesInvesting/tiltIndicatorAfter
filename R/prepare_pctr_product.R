#' Creates final output of pctr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pctr_prod A dataframe like [pctr_product]
#' @param comp A dataframe like [companies]
#'
#' @return A dataframe that prepares the final output of pctr_product
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' pctr_product <- pctr_product
#' companies <- companies
#'
#' pctr_product_final <- prepare_pctr_product(pctr_product, companies, ecoinvent_activities, matches_mapper)
#' pctr_product_final
prepare_pctr_product <- function(pctr_prod, comp, eco_activities, match_mapper) {
  final_result <- prepare_inter_pctr_product(pctr_prod, comp, eco_activities, match_mapper) |>
    relocate("companies_id", "company_name", "country", "risk_category", "grouped_by", "clustered", "activity_name", "reference_product_name",
             "unit", "multi_match", "matching_certainty", "avg_matching_certainty",
             "co2_footprint", "company_city", "postcode", "address", "main_activity",
             "activity_uuid_product_uuid") |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      benchmark = "grouped_by",
      PCTR_risk_category = "risk_category",
      ep_product = "clustered") |>
    mutate(has_na = all(is.na(PCTR_risk_category)), row_number = row_number(), .by = c("companies_id")) |>
    mutate(benchmark = ifelse(has_na & row_number != 1, NA, benchmark)) |>
    select(-c("has_na", "row_number", "isic_4digit", "isic_4digit_name_ecoinvent",
              "isic_section", "matching_certainty_num", "avg_matching_certainty_num", "co2_footprint")) |>
    filter(!is.na(benchmark)) |>
    mutate(benchmark = ifelse(is.na(PCTR_risk_category), NA, benchmark), .by = c("companies_id")) |>
    distinct() |>
    arrange(country) |>
    filter(is.na(multi_match))
}
