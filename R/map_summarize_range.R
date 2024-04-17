# TODO: Move to tiltIndicator
map_summarize_range <- function(.x, col, .by = NULL, na.rm = FALSE) {
  .x <- .x
  # TODO check that .x is a list
  # TODO check that .by is a named list
  # TODO check that .by is a named list
  # TODO check the relationship between the names of .x and .by

  out <- vector("list", length = length(.x))
  names(out) <- names(.x)
  for (i in names(.x)) {
    out[[i]] <- summarize_range(
      .x[[i]],
      col = .data[[col]], .by = all_of(.by[[i]]), na.rm = na.rm
    )
  }

  out
}
