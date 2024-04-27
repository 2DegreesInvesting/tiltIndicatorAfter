jitter_co2_range <- function(data, ...) {
  data |>
    group_by(.data[[col_grouped_by()]]) |>
    group_split() |>
    map(jitter_range, ...) |>
    reduce(bind_rows)
}
