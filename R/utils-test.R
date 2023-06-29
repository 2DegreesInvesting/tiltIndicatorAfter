#' Format data to print robust snapshots
#'
#' Prints each column separately, one under the other. This avoids differences
#' caused by the width of the screen while preserving a format that is easy
#' to compare when a real difference happens.
#'
#' @param data A data frame or named list in general
#' @examples
#' format_robust_snapshot(BOD)
#' @noRd
format_robust_snapshot <- function(data) {
  row.names(data) <- NULL
  lapply(names(data), function(x) as.data.frame(data)[x])
}
