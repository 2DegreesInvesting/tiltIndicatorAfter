create_co2_range <- function(data, amount = co2_jitter_amount()) {
  out <- data |>
    summarize_range(.data[[grep("co2_footprint", names(data), value = TRUE)]],
      .by = c("grouped_by", "risk_category")
    ) |>
    jitter_range(amount = amount) |>
    warn_if_percent_noise_is_too_high_or_too_low() |>
    rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter")

  if (co2_keep_licensed_min_max()) {
    return(out)
  }

  out |> select(-c("min", "max"))
}

add_co2_upper_lower <- function(data, co2_range) {
  left_join(data, co2_range, by = join_by("grouped_by", "risk_category"))
}

warn_if_percent_noise_is_too_high_or_too_low <- function(data) {
  min <- round(mean(percent_noise(data$min, data$min_jitter)), 2)
  max <- round(mean(percent_noise(data$max, data$max_jitter)), 2)
  if (min < 50 || max < 50 || min > 100 || max > 100) {
    rlang::warn(c(
      "The mean percent noise of the `co2*` columns is too high or too low:",
      "* `min`: {min}%",
      "* `max`: {max}%",
      i = "Do you need to adjust the `amount` of jitter? See `?tiltIndicatorAfter_options`."
    ))
  }

  invisible(data)
}
