#' Creates intermediate output of Emissions Profile results
#'
#' @return A dataframe
#' @noRd
prepare_inter_emissions_profile <- function(ep_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) {
  prepared_match_mapper <- left_join(ecoinvent_europages, ecoinvent_activities, by = "activity_uuid_product_uuid")
  ep_product_europages <- left_join(ep_prod, europages_companies, by = "companies_id")

  join_by_shared_cols_quietly <- intersect(
    names(ep_product_europages),
    names(prepared_match_mapper)
  )
  ep_product_europages |>
    left_join(prepared_match_mapper, by = join_by_shared_cols_quietly) |>
    left_join(isic, by = "isic_4digit") |>
    add_avg_matching_certainty("completion")
}
