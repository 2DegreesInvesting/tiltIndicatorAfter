# TODO: Move to tiltIndicator
# TODO check that .x is a list
# TODO check that .by is a named list
# TODO check the relationship between the names of .x and .by
map_summarize_range <- function(data, col, .by = NULL, na.rm = FALSE) {
  out <- vector("list", length = length(data))
  names(out) <- names(data)
  for (i in names(data)) {
    out[[i]] <- summarize_range2(
      data[[i]],
      col = col, .by = all_of(.by[[i]]), na.rm = na.rm
    )
  }

  out
}

# `col` is now a string now a symbol
summarize_range2 <- function(data, col, .by = NULL, na.rm = FALSE) {
  tiltIndicator::summarize_range(
    data,
    col = .data[[col]],
    .by = all_of(.by),
    na.rm = na.rm
  )
}
