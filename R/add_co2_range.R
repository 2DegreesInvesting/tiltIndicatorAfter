#' @export
#' @rdname composable_friends
add_co2_range <- function(data, ...) {
  data |>
    summarize_co2_range() |>
    jitter_co2_range(...) |>
    polish_co2_range() |>
    join_to(data)
}
