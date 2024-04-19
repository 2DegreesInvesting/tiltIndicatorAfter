#' Join every possible column and row
#'
#' This function is typically useful when you want to pipe data into a summary
#' and then join back the data to the summary. It joins by all shared columns
#' using a "many-to-many" relationship.
#'
#' @inheritParams dplyr::left_join
#'
#' @return A data frame with all columns in `x` and `y` and all rows in `y`.
#' @export
#' @keywords internal
#' @family pipable functions
#'
#' @examples
#' data <- tibble(x = 1, y = letters[c(1, 2)], z = 1:4)
#'
#' data |>
#'   dplyr::summarise(mean = mean(x), .by = "y") |>
#'   join_to(data)
#'
#' data |>
#'   dplyr::summarise(mean = mean(x), .by = "y") |>
#'   join_to(data, excluding = "z")
join_to <- function(x, y, excluding = NULL) {
  if (!is.null(excluding)) {
    y <- distinct(select(y, -matches(excluding)))
  }

  shared <- intersect(names(x), names(y))
  left_join(y, x, by = shared, relationship = "many-to-many")
}
