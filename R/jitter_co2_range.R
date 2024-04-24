#' @export
#' @rdname add_co2_range
jitter_co2_range <- function(data, ...) {
  col <- "benchmark"

  data |>
    group_by(.data[[col]]) |>
    group_split() |>
    map(jitter_range, ...) |>
    reduce(bind_rows)
}
