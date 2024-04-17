summarize_co2_range <- function(data) {
  summarize_co2_range_impl(data)
}

summarize_co2_range_impl <- function(data) {
  .benchmark <- "benchmark"
  .all <- c(.benchmark, "emission_profile")

  .x <- split(data, data[[.benchmark]])
  col <- extract_name(data, "co2_footprint")
  .by <- group_benchmark(unique(data[[.benchmark]]), .all)

  out <- map_summarize_range(.x, col = col, .by = .by)
  reduce(out, bind_rows)
}

polish_benchmark_range <- function(data, benchmark) {
  data[[benchmark]] |>
    jitter_range() |>
    select(-"min", -"max") |>
    rename(co2_lower = "min_jitter", co2_upper = "max_jitter")
}
