inform_noise_in_co2_range <- function(data) {
  if (!option_verbose()) {
    return(invisible(data))
  }

  l <- round(mean(percent_noise(data$min, data$min_jitter), na.rm = TRUE))
  u <- round(mean(percent_noise(data$max, data$max_jitter), na.rm = TRUE))
  inform(c(i = glue(
    "Adding {l}% and {u}% noise to `{col_min_jitter()}` and `{col_max_jitter()}`, respectively."
  )))

  invisible(data)
}
