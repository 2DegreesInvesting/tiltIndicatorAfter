create_co2_range <- function(data, amount = co2_jitter_amount()) {
  out <- data |>
    summarize_range(.data[[grep("co2_footprint", names(data), value = TRUE)]],
      .by = c("grouped_by", "risk_category")
    ) |>
    jitter_range(amount = amount)

  out |> inform_mean_percent_noise()

  out <- out |> rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter")

  if (co2_keep_licensed_min_max()) {
    return(out)
  }

  out |> select(-c("min", "max"))
}

add_co2_upper_lower <- function(data, co2_range) {
  left_join(data, co2_range, by = join_by("grouped_by", "risk_category"))
}

inform_mean_percent_noise <- function(data) {
  if (!verbose()) {
    return(data)
  }

  l <- round(mean(percent_noise(data$min, data$min_jitter)))
  u <- round(mean(percent_noise(data$max, data$max_jitter)))
  rlang::inform(c(i = glue(
    "Adding {l}% and {u}% noise to `co2e_lower` and `co2e_upper`, respectively."
  )))

  invisible(data)
}
