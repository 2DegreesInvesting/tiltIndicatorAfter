#' Creates final output of ictr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param ictr_prod A dataframe like [ictr_product]
#' @param comp A dataframe like [ep_companies]
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
#' ep_companies <- ep_companies
#' ecoinvent_inputs <- ecoinvent_inputs
#'
#' ictr_product_final <- prepare_ictr_product(
#'   ictr_product,
#'   ep_companies,
#'   ecoinvent_activities,
#'   matches_mapper,
#'   ecoinvent_inputs
#' )
#' ictr_product_final
prepare_ictr_product <- function(ictr_prod, comp, eco_activities, match_mapper, eco_inputs) {
  match_mapper <- prepare_matches_mapper(match_mapper, eco_activities) |>
    select("country", "main_activity", "clustered", "activity_uuid_product_uuid", "multi_match", "completion")

  ictr_prod |>
    left_join(eco_inputs, by = "input_activity_uuid_product_uuid") |>
    distinct() |>
    select(-c("input_activity_uuid_product_uuid", "input_co2_footprint")) |>
    left_join(comp, by = "companies_id") |>
    left_join(eco_activities, by = "activity_uuid_product_uuid") |>
    left_join(match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    add_avg_matching_certainty("completion") |>
    exclude_rows("risk_category") |>
    relocate_ictr_product() |>
    rename_ictr_product() |>
    mutate(benchmark = ifelse(is.na(.data$ICTR_risk_category), NA, .data$benchmark), .by = c("companies_id")) |>
    select(-c(
      "matching_certainty_num", "avg_matching_certainty_num", "geography"
    )) |>
    distinct() |>
    arrange(.data$country)
}

rename_ictr_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      benchmark = "grouped_by",
      ep_product = "clustered",
      ICTR_risk_category = "risk_category",
      input_name = "exchange_name",
      input_unit = "exchange_unit_name"
    )
}

relocate_ictr_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "grouped_by",
      "clustered", "activity_name", "reference_product_name",
      "unit", "multi_match", "matching_certainty", "avg_matching_certainty", "exchange_name",
      "exchange_unit_name", "company_city", "postcode", "address", "main_activity",
      "activity_uuid_product_uuid"
    )
}