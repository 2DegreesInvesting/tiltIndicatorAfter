#' Prepare mapper for multiple matches
#'
#' @param mapper A dataframe like [matches_mapper]
#' @param activities A dataframe like [ecoinvent_activities]
#'
#' @return A dataframe that contains information on multiple matches
#' @noRd
prepare_matches_mapper <- function(mapper, activities) {
  activities <- activities |>
    select("activity_uuid_product_uuid", "activity_name", "reference_product_name", "unit")

  mapper |>
    left_join(activities, by = "activity_uuid_product_uuid") |>
    summarise(across(everything(), ~ paste0(na.omit(unique(.)), collapse = "; ")), .by = c("country", "main_activity", "clustered")) |>
    ungroup() |>
    mutate_all(~ifelse(. == "", NA_character_, .)) |>
    distinct() |>
    mutate(multi_match = case_when(
      is.na(multi_match) ~ "FALSE",
      TRUE ~ multi_match
    ))
}
