#' Creates intermediate output of pctr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pctr_prod A dataframe like [pctr_product]
#' @param comp A dataframe like [ep_companies]
#'
#' @return A dataframe that prepares the intermediate output of pctr_product
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' pctr_product <- pctr_product
#' ep_companies <- ep_companies
#'
#' pctr_product_inter <- prepare_inter_pctr_product(
#'   pctr_product,
#'   ep_companies,
#'   ecoinvent_activities,
#'   matches_mapper
#' )
#' pctr_product_inter
prepare_inter_pctr_product <- function(pctr_prod, comp, eco_activities, match_mapper) {
  prepared_match_mapper <- prepare_matches_mapper(match_mapper, eco_activities) |>
    select(
      "country", "main_activity", "clustered", "activity_uuid_product_uuid", "multi_match",
      "completion", "activity_name", "reference_product_name", "unit"
    )

  pctr_prod <- pctr_prod |>
    left_join(comp, by = "companies_id") |>
    left_join(prepared_match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    add_avg_matching_certainty("completion") |>
    exclude_rows("risk_category")
}
