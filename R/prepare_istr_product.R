#' Creates final output of istr product level results
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param istr_prod A dataframe like [istr_product]
#' @param comp A dataframe like [ep_companies]
#' @param eco_inputs A dataframe like [ecoinvent_inputs]
#'
#' @return A dataframe that prepares the final output of istr_product
#'
#' @export
#'
#' @examples
#' prepare_istr_product(
#'   istr_product |> head(3),
#'   ep_companies |> head(3),
#'   ecoinvent_activities |> head(3),
#'   matches_mapper |> head(3),
#'   ecoinvent_inputs |> head(3)
#' )
prepare_istr_product <- function(istr_prod, comp, eco_activities, match_mapper, eco_inputs) {

  istr_prod |>
    left_join(eco_inputs, by = "input_activity_uuid_product_uuid") |>
    select(-c("input_activity_uuid_product_uuid")) |>
    distinct() |>
    left_join(comp, by = "companies_id") |>
    left_join(eco_activities, by = "activity_uuid_product_uuid") |>
    left_join(match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    add_avg_matching_certainty("completion") |>
    exclude_rows("risk_category") |>
    relocate_istr_product() |>
    rename_istr_product() |>
    mutate(scenario = recode(.data$scenario, "1.5c rps" = "IPR 1.5c RPS", "nz 2050" = "WEO NZ 2050")) |>
    select(-c("matching_certainty_num", "avg_matching_certainty_num", "grouped_by", "type", "geography")) |>
    distinct() |>
    arrange(.data$country)
}

rename_istr_product <- function(data) {
  data |>
    rename(
      matched_activity_name = "activity_name",
      matched_reference_product = "reference_product_name",
      matching_certainty_company_average = "avg_matching_certainty",
      ep_product = "clustered",
      ISTR_risk_category = "risk_category",
      input_name = "exchange_name",
      input_unit = "exchange_unit_name"
    )
}

relocate_istr_product <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "country", "risk_category", "scenario", "year",
      "clustered", "activity_name", "reference_product_name",
      "unit", "tilt_sector", "multi_match", "matching_certainty", "avg_matching_certainty",
      "exchange_name", "exchange_unit_name", "input_tilt_sector", "input_tilt_subsector",
      "company_city", "postcode", "address", "main_activity",
      "activity_uuid_product_uuid"
    )
}
