#' Creates final output of ictr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pctr_prod A dataframe like [pctr_product]
#' @param comp A dataframe like [companies]
#' @param eco_inputs A dataframe like [ecoinvent_inputs]
#'
#' @return A dataframe that prepares the final output of ictr_product
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' ictr_product <- ictr_product
#' companies <- companies
#' ecoinvent_inputs <- ecoinvent_inputs
#'
#' ictr_product <- prepare_ictr_product(ictr_product, companies, ecoinvent_activities, matches_mapper, ecoinvent_inputs)
#' ictr_product
prepare_ictr_product <- function(ictr_prod, comp, eco_activities, match_mapper, eco_inputs) {
  eco_inputs <- eco_inputs |>
    select("input_activity_uuid_product_uuid", "exchange_name", "exchange_unit_name") |>
    distinct()
  comp <- comp |>
    select("company_name", "country", "company_city", "postcode", "address", "main_activity", "companies_id") |>
    distinct()
  match_mapper <- prepare_matches_mapper(match_mapper, eco_activities) |>
    # Different for ICTR
    select("country", "main_activity", "clustered", "activity_uuid_product_uuid", "multi_match", "completion")

  ictr_prod <- ictr_prod |>
    left_join(eco_inputs, by = "input_activity_uuid_product_uuid") |>
    distinct() |>
    select(-c("input_activity_uuid_product_uuid", "input_co2_footprint")) |>
    left_join(comp, by = "companies_id") |>
    left_join(eco_activities, by = "activity_uuid_product_uuid") |>
    # same as in PCTR
    left_join(match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    rename(matching_certainty = completion) |>
    mutate(matching_certainty_num = case_when(
      matching_certainty == "low" ~ 0,
      matching_certainty == "medium" ~ 0.5,
      matching_certainty == "high" ~ 1,
    )) |>
    mutate(avg_matching_certainty_num = mean(matching_certainty_num, na.rm = TRUE), .by = c("companies_id")) |>
    mutate(avg_matching_certainty = case_when(
      avg_matching_certainty_num > 2/3 ~ "high",
      avg_matching_certainty_num <= 2/3 & avg_matching_certainty_num > 1/3 ~ "medium",
      avg_matching_certainty_num <= 1/3 ~ "low"
    )) |>
    relocate("companies_id", "company_name", "country", "risk_category", "grouped_by",
             "clustered", "activity_name", "reference_product_name",
             "unit", "multi_match", "matching_certainty", "avg_matching_certainty",
             "company_city", "postcode", "address", "main_activity",
             "activity_uuid_product_uuid") |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      benchmark = "grouped_by",
      ep_product = "clustered",
      ICTR_risk_category = "risk_category",
      input_name = "exchange_name",
      input_unit = "exchange_unit_name") |>
    keep_first_row("ICTR_risk_category") |>
    mutate(benchmark = ifelse(is.na(ICTR_risk_category), NA, benchmark), .by = c("companies_id")) |>
    select(-c("has_na", "row_number", "isic_4digit", "isic_4digit_name_ecoinvent",
              "isic_section", "matching_certainty_num", "avg_matching_certainty_num")) |>
    distinct() |>
    arrange(country)
}
