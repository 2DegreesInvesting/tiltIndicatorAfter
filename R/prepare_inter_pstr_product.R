#' Creates intermediate output of pstr product level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param pstr_prod A dataframe like [pstr_product]
#' @param comp A dataframe like [companies]
#'
#' @return A dataframe that prepares the intermediate output of pstr_product
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#' pstr_product <- pstr_product
#' companies <- companies
#'
#' pstr_product_inter <- prepare_inter_pstr_product(pstr_product, companies, ecoinvent_activities, matches_mapper)
#' pstr_product_inter
prepare_inter_pstr_product <- function(pstr_prod, comp, eco_activities, match_mapper) {
  no_NAs <- pstr_prod |>
    filter(!is.na(risk_category))

  # select company ids where all `risk_category` is only `NA`
  ids <- pstr_prod |>
    group_by(companies_id) |>
    filter(all(is.na(risk_category))) |>
    distinct(companies_id)

  pstr_prod_level <- bind_rows(no_NAs, ids)

  comp <- comp |>
    select("company_name", "country", "company_city", "postcode", "address", "main_activity", "companies_id") |>
    distinct()
  # different for PSTR due to some missing column names
  match_mapper <- prepare_matches_mapper(match_mapper, eco_activities) |>
    select("country", "main_activity", "clustered", "activity_uuid_product_uuid", "multi_match", "completion")
  # different for PSTR due to activity_name and unit
  activities <- eco_activities |>
    select("activity_uuid_product_uuid", "isic_4digit", "reference_product_name", "isic_4digit_name_ecoinvent", "isic_section", "activity_name", "unit")

  pstr_prod_level <- pstr_prod_level |>
    left_join(comp, by = "companies_id") |>
    left_join(activities, by = "activity_uuid_product_uuid") |>
    left_join(match_mapper, by = c("country", "main_activity", "clustered", "activity_uuid_product_uuid")) |>
    rename(matching_certainty = completion) |>
    mutate(matching_certainty_num = categorize_matching_certainity(matching_certainty)) |>
    mutate(avg_matching_certainty_num = mean(matching_certainty_num, na.rm = TRUE), .by = c("companies_id")) |>
    mutate(avg_matching_certainty = categorize_avg_matching_certainity(avg_matching_certainty_num))
}
