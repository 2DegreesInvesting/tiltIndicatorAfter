#' Creates intermediate output of pstr product level results
#'
#' @inheritParams prepare_ictr_company
#'
#' @return A dataframe that prepares the intermediate output of pstr_product
#' @noRd
prepare_inter_pstr_product <- function(pstr_prod, comp, eco_activities, match_mapper, isic_tilt_map) {
  pstr_prod |>
    left_join(comp, by = "companies_id") |>
    left_join(eco_activities, by = "activity_uuid_product_uuid") |>
    left_join(match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    left_join(isic_tilt_map, by = "isic_4digit") |>
    add_avg_matching_certainty("completion") |>
    exclude_rows("risk_category")
}
