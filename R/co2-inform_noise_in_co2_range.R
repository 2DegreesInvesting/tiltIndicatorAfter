inform_noise_in_co2_range <- function(data) {
  if (!verbose()) {
    return(invisible(data))
  }

  l <- round(mean(percent_noise(data$min, data$min_jitter), na.rm = TRUE))
  u <- round(mean(percent_noise(data$max, data$max_jitter), na.rm = TRUE))
  inform(c(i = glue(
    "Adding {l}% and {u}% noise to `co2e_lower` and `co2e_upper`, respectively."
  )))

  invisible(data)
}
