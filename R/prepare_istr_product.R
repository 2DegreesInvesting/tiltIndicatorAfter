#' Creates final output of istr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param istr_prod A dataframe like [istr_product]
#' @param comp A dataframe like [companies]
#' @param eco_inputs A dataframe like [ecoinvent_inputs]
#'
#' @return A dataframe that prepares the final output of istr_product
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' istr_product <- istr_product
#' companies <- companies
#' ecoinvent_inputs <- ecoinvent_inputs
#'
#' istr_product_final <- prepare_istr_product(istr_product, companies, ecoinvent_activities, matches_mapper, ecoinvent_inputs)
#' istr_product_final
prepare_istr_product <- function(istr_prod, comp, eco_activities, match_mapper, eco_inputs) {
  istr_prod_level <- exclude_rows(istr_prod)
  match_mapper <- prepare_matches_mapper(match_mapper, eco_activities) |>
    # Different for ISTR
    select("country", "main_activity", "clustered", "activity_uuid_product_uuid", "multi_match", "completion")

  istr_prod_level <- istr_prod_level |>
    left_join(eco_inputs, by = "input_activity_uuid_product_uuid") |>
    distinct() |>
    select(-c("input_activity_uuid_product_uuid")) |>
    left_join(comp, by = "companies_id") |>
    left_join(eco_activities, by = "activity_uuid_product_uuid") |>
    # same as in PSTR
    left_join(match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    rename(matching_certainty = "completion") |>
    mutate(matching_certainty_num = categorize_matching_certainity(.data$matching_certainty)) |>
    mutate(avg_matching_certainty_num = mean(.data$matching_certainty_num, na.rm = TRUE), .by = c("companies_id")) |>
    mutate(avg_matching_certainty = categorize_avg_matching_certainity(.data$avg_matching_certainty_num)) |>
    relocate_istr_product() |>
    rename_istr_product() |>
    select(-c("isic_4digit", "isic_4digit_name_ecoinvent",
              "isic_section", "matching_certainty_num", "avg_matching_certainty_num")) |>
    distinct() |>
    arrange(.data$country)
}

rename_istr_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      benchmark = "grouped_by",
      ep_product = "clustered",
      ISTR_risk_category = "risk_category",
      input_name = "exchange_name",
      input_unit = "exchange_unit_name"
    )
}

relocate_istr_product <- function(data) {
  data |>
    relocate("companies_id", "company_name", "country", "risk_category", "scenario", "year",
           "clustered", "activity_name", "reference_product_name",
           "unit", "tilt_sector", "multi_match", "matching_certainty", "avg_matching_certainty",
           "exchange_name", "exchange_unit_name", "input_tilt_sector", "input_tilt_subsector",
           "company_city", "postcode", "address", "main_activity",
           "activity_uuid_product_uuid", "grouped_by")
}
