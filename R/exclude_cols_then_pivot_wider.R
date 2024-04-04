#' Excluding irrelevant columns and duplicates, then pivot from long to wide
#'
#' @param data A data frame to pivot.
#' @param ... Arguments passed to [tidyr::pivot_wider()].
#' @param exclude_cols A character vector giving regular expressions matching
#'   column names to exclude. If lengh > 1, the union is taken.
#'
#' @return A data frame giving the result you get from [tidyr::pivot_wider()] if
#'   `data` lacks the excluded columns and the resulting duplicates.
#' @export
#' @keywords internal
#'
#' @examples
#' library(tidyr, warn.conflicts = FALSE)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' data <- tribble(
#'   ~to_exclude,  ~id, ~name,  ~value,
#'             1, "id",   "a",       1,
#'             2, "id",   "a",       1,
#'             1, "id",   "b",       2,
#'             2, "id",   "b",       2,
#' )
#'
#' # `exclude_cols_then_pivot_wider()` excludes columns and duplicates
#' data |> exclude_cols_then_pivot_wider(exclude_cols = "exclude")
#'
#' # Why is this useful?
#' # `pivot_wider()` defaults to using all columns
#' data |> pivot_wider()
#'
#' # You may specify relevant columns but the result may still have duplicates
#' data |>
#'   pivot_wider(id_cols = id, names_from = "name", values_from = "value") |>
#'   unnest(c(a, b))
exclude_cols_then_pivot_wider <- function(data, ..., exclude_cols = NULL) {
  data |>
    select(-matches(exclude_cols)) |>
    distinct() |>
    pivot_wider(...)
}


