#' Prepare mapper for multiple matches
#'
#' @param mapper A dataframe like [matches_mapper]
#' @param activities A dataframe like [ecoinvent_activities]
#'
#' @return A dataframe that contains information on multiple matches
#'
#' @export
#'
#' @examples
#' matches_mapper <- matches_mapper
#' ecoinvent_activities <- ecoinvent_activities
#'
#' output <- prepare_matches_mapper(matches_mapper, ecoinvent_activities)
#' output
prepare_matches_mapper <- function(mapper, activities) {
  # first join activity_name, reference_product_name, and unit to mapper and
  # then aggregate for multiple matches of country, main_activity, clustered.
  # replace empty cells with FALSE

  activities <- activities |>
    select("activity_uuid_product_uuid", "activity_name", "reference_product_name", "unit")

  mapper <- mapper |>
    left_join(activities, by = "activity_uuid_product_uuid") |>
    group_by("country", "main_activity", "clustered") |>
    summarise(across(everything(), ~ paste0(na.omit(unique(.)), collapse = "; "))) |>
    ungroup() |>
    distinct() |>
    mutate(multi_match = case_when(
      multi_match == "" ~ "FALSE",
      TRUE   ~ multi_match
    ))
}
