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
#' functions in the pipable API
#'
#' @examples
#' data <- tibble(x = 1:4, y = letters[c(1, 1, 2, 2)])
#'
#' data |>
#'   dplyr::summarise(z = mean(x), .by = "y") |>
#'   join_everything(data)
join_everything <- function(x, y) {
  shared <- intersect(names(x), names(y))
  right_join(y, x, by = shared, relationship = "many-to-many")
}
