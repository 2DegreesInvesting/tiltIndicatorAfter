#' Creates final output of ictr product level results
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param ictr_prod A dataframe like [ictr_product]
#' @param comp A dataframe like [ep_companies]
#' @param eco_inputs A dataframe like [ecoinvent_inputs]
#' @param isic_tilt_map A dataframe like [isic_tilt_mapper]
#'
#' @return A dataframe that prepares the final output of ictr_product
#'
#' @export
#'
#' @examples
#' prepare_ictr_product(
#'   ictr_product |> head(3),
#'   ep_companies |> head(3),
#'   ecoinvent_activities |> head(3),
#'   matches_mapper |> head(3),
#'   ecoinvent_inputs |> head(3),
#'   isic_tilt_mapper |> head(3)
#' )
prepare_ictr_product <- function(ictr_prod, comp, eco_activities, match_mapper, eco_inputs, isic_tilt_map) {
  ictr_prod <- sanitize_isic(ictr_prod)

  ictr_prod |>
    left_join(eco_inputs, by = "input_activity_uuid_product_uuid") |>
    select(-c("input_activity_uuid_product_uuid", "input_co2_footprint")) |>
    distinct() |>
    left_join(comp, by = "companies_id") |>
    left_join(isic_tilt_map, by = join_by("input_isic_4digit" == "isic_4digit")) |>
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
    arrange(.data$country) |>
    distinct()
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
      input_unit = "exchange_unit_name",
      input_isic_name = "isic_4digit_name_ecoinvent"
    )
}

relocate_ictr_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "grouped_by",
      "clustered", "activity_name", "reference_product_name",
      "unit", "multi_match", "matching_certainty", "avg_matching_certainty", "exchange_name",
      "exchange_unit_name", "input_tilt_sector", "input_tilt_subsector", "input_isic_4digit", "isic_4digit_name_ecoinvent",
      "company_city", "postcode", "address", "main_activity", "activity_uuid_product_uuid"
    )
}
