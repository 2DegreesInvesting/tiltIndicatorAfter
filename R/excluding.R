#' Exclude columns matching a pattern
#'
#' Shortcut for `select(data, -matches(match))`.
#'
#' @inheritParams dplyr::select
#' @inheritParams tidyselect::matches
#'
#' @return A dataframe.
#' @export
#' @keywords internal
#' @family pipable functions
#'
#' @examples
#' data <- tibble::tibble(x = 1, y = 2, yy = 3)
#' data |> excluding("yy")
#'
#' data |> excluding("y")
#'
#' data |> excluding(c("x", "yy"))
excluding <- function(data, match) {
  select(data, -matches(match))
}
