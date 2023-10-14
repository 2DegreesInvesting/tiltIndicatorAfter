#' Prepare mapper for multiple matches
#'
#' @param mapper A dataframe like [matches_mapper]
#' @param activities A dataframe like [ecoinvent_activities]
#'
#' @return A dataframe that contains information on multiple matches
#' @noRd
prepare_matches_mapper <- function(mapper, activities) {
  stopifnot(is.logical(mapper$multi_match))
  activities <- activities |>
    select("activity_uuid_product_uuid", "activity_name", "reference_product_name", "unit")

  mapper_df <- mapper |>
    left_join(activities, by = "activity_uuid_product_uuid")
  stop_if_some_columns_have_more_than_one_unique_value(mapper_df)

  non_summarised_df <- mapper_df |>
    select(-c("activity_uuid_product_uuid", "activity_name")) |>
    summarise(across(everything(), \(x) unique(x)), .by = c("country", "main_activity", "clustered"))
  summarised_df <- mapper_df |>
    select(c("country", "main_activity", "clustered", "activity_uuid_product_uuid", "activity_name")) |>
    summarise(across(everything(), \(x) paste0(na.omit(unique(x)), collapse = "; ")), .by = c("country", "main_activity", "clustered"))

  non_summarised_df |>
    left_join(summarised_df, by = c("country", "main_activity", "clustered")) |>
    mutate(across(everything(), \(x) ifelse(!nzchar(x), NA_character_, x))) |>
    distinct() |>
    mutate(multi_match = ifelse(is.na(.data$multi_match), FALSE, TRUE))
}
