#' Title
#'
#' @param data A dataframe.
#' @param excluding Character vector with patterns to exclude columns and any
#'   resulting duplicate.
#'
#' @return
#' @export
#'
#' @examples
#'
exclude <- function(data, excluding) {
  distinct(select(data, -matches(excluding)))
}
