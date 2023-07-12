#' Creates intermediate output of pstr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pstr_prod A dataframe like [pstr_product]
#' @param comp A dataframe like [ep_companies]
#'
#' @return A dataframe that prepares the intermediate output of pstr_product
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' pstr_product <- pstr_product
#' ep_companies <- ep_companies
#'
#' pstr_product_inter <- prepare_inter_pstr_product(
#'   pstr_product,
#'   ep_companies,
#'   ecoinvent_activities,
#'   matches_mapper
#' )
#' pstr_product_inter
prepare_inter_pstr_product <- function(pstr_prod, comp, eco_activities, match_mapper) {
  pstr_prod_level <- exclude_rows(pstr_prod)

  match_mapper <- prepare_matches_mapper(match_mapper, eco_activities) |>
    select("country", "main_activity", "clustered", "activity_uuid_product_uuid", "multi_match", "completion")

  activities <- eco_activities |>
    select("activity_uuid_product_uuid", "isic_4digit", "reference_product_name", "isic_4digit_name_ecoinvent", "isic_section", "activity_name", "unit")

  pstr_prod_level |>
    left_join(comp, by = "companies_id") |>
    left_join(activities, by = "activity_uuid_product_uuid") |>
    left_join(match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    add_avg_matching_certainty("completion")
}
