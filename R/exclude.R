#' Title
#'
#' @param data A dataframe.
#' @param excluding Character vector with patterns to exclude columns and any
#'   resulting duplicate.
#'
#' @return
#' @export
#' @family composable friends
#'
#' @examples
#' # Excludes columns along with all its duplicates
#' data <- tibble(x = 1, y = 1:2)
#' data
#' data |> exclude("y")
#'
#' # Columns are matched as a regular expression
#' data <- tibble(x = 1, yz = 1:2, zy = 1)
#' data
#' data |> exclude("y")
#' data |> exclude("y$")
exclude <- function(data, excluding) {
  distinct(select(data, -matches(excluding)))
}
