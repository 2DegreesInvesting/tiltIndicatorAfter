summarize_range3 <- function(data, col, .by = NULL, na.rm = FALSE) {
  UseMethod("summarize_range3")
}

# `col` is now a string now a symbol
summarize_range3.data.frame <- function(data, col, .by = NULL, na.rm = FALSE) {
  tiltIndicator::summarize_range(
    data,
    col = .data[[col]],
    .by = all_of(.by),
    na.rm = na.rm
  )
}

# TODO: Move to tiltIndicator
# TODO check that .x is a list
# TODO check that .by is a named list
# TODO check the relationship between the names of .x and .by
summarize_range3.list <- function(data, col, .by = NULL, na.rm = FALSE) {
  out <- vector("list", length = length(data))
  names(out) <- names(data)
  for (i in names(data)) {
    out[[i]] <- summarize_range3(
      data[[i]],
      col = col,
      .by = all_of(.by[[i]]),
      na.rm = na.rm
    )
  }

  out
}

