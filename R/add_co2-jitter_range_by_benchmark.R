jitter_range_by_benchmark <- function(data, ...) {
  data |>
    group_by(.data[[col_benchmark()]]) |>
    group_split() |>
    map(jitter_range, ...) |>
    reduce(bind_rows)
}
