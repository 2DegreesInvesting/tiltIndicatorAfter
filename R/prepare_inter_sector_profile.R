#' Creates intermediate output of Sector Profile results
#'
#' @return A dataframe
#' @noRd
prepare_inter_sector_profile <- function(sp_prod, europages_companies, ecoinvent_activities, ecoinvent_europages, isic) {
  sp_prod |>
    left_join(europages_companies, by = "companies_id") |>
    left_join(ecoinvent_activities, by = "activity_uuid_product_uuid") |>
    left_join(ecoinvent_europages, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    left_join(isic, by = "isic_4digit") |>
    add_avg_matching_certainty("completion")
}
