create_co2_range <- function(data, amount = co2_jitter_amount()) {
  out <- data |>
    summarize_range(.data[[grep("co2_footprint", names(data), value = TRUE)]],
      .by = c("grouped_by", "risk_category")
    ) |>
    jitter_range(amount = amount)

  out |> warn_mean_percent_noise_outside_range()

  out <- out |> rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter")

  if (co2_keep_licensed_min_max()) {
    return(out)
  }

  out |> select(-c("min", "max"))
}

add_co2_upper_lower <- function(data, co2_range) {
  left_join(data, co2_range, by = join_by("grouped_by", "risk_category"))
}

warn_mean_percent_noise_outside_range <- function(data,
                                                  min = 40,
                                                  max = 80) {
  if (!verbose()) return(data)

  min_actual <- round(mean(percent_noise(data$min, data$min_jitter)), 2)
  max_actual <- round(mean(percent_noise(data$max, data$max_jitter)), 2)
  if (min_actual < min ||
      max_actual < min ||
      min_actual > max ||
      max_actual > max) {
    rlang::warn(c(
      glue("The mean percent noise of `co2*` is outside the range {min}%-{max}%."),
      i = glue("Actual values:
        * `min`: {min}%
        * `max`: {max}%"),
      i = "Do you need to adjust the jitter `amount`? See `?tiltIndicatorAfter_options`."
    ))
  }

  invisible(data)
}
