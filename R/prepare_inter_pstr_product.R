#' Creates intermediate output of pstr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pstr_prod A dataframe like [pstr_product]
#' @param comp A dataframe like [ep_companies]
#' @param isic_tilt_map A dataframe like [isic_tilt_mapper]
#'
#' @return A dataframe that prepares the intermediate output of pstr_product
#' @noRd
prepare_inter_pstr_product <- function(pstr_prod, comp, eco_activities, match_mapper, isic_tilt_map) {
  activities <- eco_activities |>
    select("activity_uuid_product_uuid", "reference_product_name", "activity_name", "unit")

  pstr_prod |>
    left_join(comp, by = "companies_id") |>
    left_join(activities, by = "activity_uuid_product_uuid") |>
    left_join(match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    left_join(isic_tilt_map, by = "isic_4digit") |>
    add_avg_matching_certainty("completion") |>
    exclude_rows("risk_category")
}
