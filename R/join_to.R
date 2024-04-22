#' Join every possible column and row
#'
#' This function is typically useful when you want to pipe data into a summary
#' and then join back the data to the summary. It joins by all shared columns
#' using a "many-to-many" relationship.
#'
#' @inheritParams dplyr::left_join
#'
#' @return A data frame with all columns in `x` and `y` and all rows in `y`,
#'   except the columns and resulting duplicates matched by the argument
#'   `excluding`.
#' @export
#' @keywords internal
#' @family composable friends
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#'
#' data <- tibble(x = rep(1, 4), y = letters[rep(c(1, 2), 2)], z = 1:4)
#' data
#'
#' data |>
#'   summarize(mean = mean(x), .by = "y") |>
#'   join_to(data)
#'
#' data |>
#'   summarize(mean = mean(x), .by = "y") |>
#'   join_to(data|> excluding("z"))
join_to <- function(x, y, excluding = NULL) {
  shared <- intersect(names(x), names(y))
  left_join(y, x, by = shared, relationship = "many-to-many")
}
