#' Creates intermediate output of pctr product level results
#'
#' @inheritParams prepare_ictr_company
#'
#' @return A dataframe that prepares the intermediate output of pctr_product
#' @noRd
prepare_inter_pctr_product <- function(pctr_prod, comp, eco_activities, match_mapper, isic_tilt_map) {
  prepared_match_mapper <- left_join(match_mapper, eco_activities, by = "activity_uuid_product_uuid")
  pctr_prod_comp <- left_join(pctr_prod, comp, by = "companies_id")

  join_by_shared_cols_quietly <- intersect(
    names(pctr_prod_comp),
    names(prepared_match_mapper)
  )
  pctr_prod_comp |>
    left_join(prepared_match_mapper, by = join_by_shared_cols_quietly) |>
    left_join(isic_tilt_map, by = "isic_4digit") |>
    add_avg_matching_certainty("completion") |>
    exclude_rows("risk_category")
}
