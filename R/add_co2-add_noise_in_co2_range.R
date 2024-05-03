add_noise_in_co2_range <- function(data) {
  round_mean <- function(x, y) round(mean(percent_noise(x, y), na.rm = TRUE))
  data |>
    mutate(
      min_noise_percent = round_mean(.data$min, .data$min_jitter), na.rm = TRUE,
      max_noise_percent = round_mean(.data$max, .data$max_jitter), na.rm = TRUE
    )
}
