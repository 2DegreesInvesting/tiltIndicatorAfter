#' @export
#' @rdname summarize_co2_range
polish_co2_range <- function(data) {
  data |>
    rename(co2_lower = "min_jitter", co2_upper = "max_jitter") |>
    select(-c("min", "max"))
}
