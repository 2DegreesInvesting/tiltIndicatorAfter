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
  match_mapper <- prepare_matches_mapper(match_mapper, eco_activities) |>
    select(
      "country", "main_activity", "clustered", "activity_uuid_product_uuid", "multi_match",
      "completion", "activity_name", "reference_product_name", "unit"
    )
  activities <- eco_activities |>
    select("activity_uuid_product_uuid", "isic_4digit", "isic_4digit_name_ecoinvent", "isic_section")

  pctr_prod <- pctr_prod |>
    left_join(comp, by = "companies_id") |>
    left_join(activities, by = "activity_uuid_product_uuid") |>
    left_join(match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    rename(matching_certainty = "completion") |>
    mutate(matching_certainty_num = categorize_matching_certainity(.data$matching_certainty)) |>
    mutate(avg_matching_certainty_num = mean(.data$matching_certainty_num, na.rm = TRUE), .by = c("companies_id")) |>
    mutate(avg_matching_certainty = categorize_avg_matching_certainity(.data$avg_matching_certainty_num))
}

categorize_avg_matching_certainity <- function(x, ...) {
  case_when(
    x > 2 / 3 ~ "high",
    x > 1 / 3 & x <= 2 / 3 ~ "medium",
    x <= 1 / 3 ~ "low",
    ...
  )
}

categorize_matching_certainity <- function(x, ...) {
  case_when(
    x == "high" ~ 1,
    x == "medium" ~ 0.5,
    x == "low" ~ 0,
    ...
  )
}
