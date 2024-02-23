create_co2_range <- function(data) {
  data |>
    summarize_range(.data[[grep("co2_footprint", names(data), value = TRUE)]],
                    .by = c("grouped_by", "risk_category")) |>
    jitter_range(amount = 0.9) |>
    stop_if_percent_noise_more_than_100() |>
    select(-c("min", "max")) |>
    rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter")
}

add_co2_upper_lower <- function(data, co2_range) {
  left_join(data, co2_range, by = join_by("grouped_by", "risk_category"))
}

stop_if_percent_noise_more_than_100 <- function(data) {
  check_noise <- data |>
    mutate(max_percent_noise = percent_noise(.data$max, .data$max_jitter),
           min_percent_noise = percent_noise(.data$min, .data$min_jitter))

  if (any(check_noise$max_percent_noise > 100) | any(check_noise$min_percent_noise > 100)) {
    abort(glue("`jitter_range` should not add more than 100% of noise to `max` and `min` columns.
               Please readjust the value of `amount` parameter in `jitter_range` function"))
  }
  invisible(data)
}
