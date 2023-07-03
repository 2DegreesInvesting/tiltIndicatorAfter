#' Creates final output of pstr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pstr_prod A dataframe like [pstr_product]
#' @param comp A dataframe like [companies]
#'
#' @return A dataframe that prepares the final output of pstr_product
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' pstr_product <- pstr_product
#' companies <- companies
#'
#' pstr_product_final <- prepare_pstr_product(pstr_product, companies, ecoinvent_activities, matches_mapper)
#' pstr_product_final
prepare_pstr_product <- function(pstr_prod, comp, eco_activities, match_mapper) {

  final_result <- prepare_inter_pstr_product(pstr_prod, comp, eco_activities, match_mapper) |>
    # Different for PSTR than PCTR
    relocate("companies_id", "company_name", "country", "risk_category", "scenario", "year",
             "clustered", "activity_name", "reference_product_name",
             "unit", "tilt_sector", "tilt_subsector", "multi_match", "matching_certainty", "avg_matching_certainty",
             "company_city", "postcode", "address", "main_activity",
             "activity_uuid_product_uuid") |>
    rename_pstr_product() |>
    mutate(scenario = ifelse(scenario == "1.5c rps", "IPR 1.5c RPS", scenario)) |>
    mutate(scenario = ifelse(scenario == "nz 2050", "WEO NZ 2050", scenario)) |>
    select(-c("isic_4digit", "isic_4digit_name_ecoinvent",
              "isic_section", "matching_certainty_num", "avg_matching_certainty_num", "grouped_by", "type")) |>
    distinct()
}

rename_pstr_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      PSTR_risk_category = "risk_category",
      ep_product = "clustered"
    )
}
