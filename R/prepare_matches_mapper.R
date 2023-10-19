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
    left_join(activities, by = "activity_uuid_product_uuid") |>
    select(-c("activity_uuid_product_uuid", "activity_name")) |>
    distinct() |>
    stop_if_some_columns_have_more_than_one_unique_value()

  one_row_df <- mapper_df |>
    filter(n() == 1, .by = c("country", "main_activity", "clustered"))
  two_row_df <- mapper_df |>
    filter(n() > 1, .by = c("country", "main_activity", "clustered")) |>
    na.omit()
  non_summarised_df <- rbind(one_row_df, two_row_df)

  summarised_df <-  mapper |>
    left_join(activities, by = "activity_uuid_product_uuid") |>
    select(c("country", "main_activity", "clustered", "activity_uuid_product_uuid", "activity_name")) |>
    summarise(across(everything(), \(x) paste0(na.omit(unique(x)), collapse = "; ")), .by = c("country", "main_activity", "clustered"))

  non_summarised_df |>
    left_join(summarised_df, by = c("country", "main_activity", "clustered")) |>
    mutate(across(everything(), \(x) ifelse(!nzchar(x), NA_character_, x))) |>
    distinct() |>
    replace_na(list(multi_match = FALSE))
}
