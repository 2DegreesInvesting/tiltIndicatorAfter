summarize_benchmark_range <- function(data, benchmark) {
  data |>
    summarize_benchmark_range_impl() |>
    polish_benchmark_range(benchmark)
}

polish_benchmark_range <- function(data, benchmark) {
  data[[benchmark]] |>
    jitter_range() |>
    select(-"min", -"max") |>
    rename(co2_lower = min_jitter, co2_upper = max_jitter)
}

summarize_benchmark_range_impl <- function(data) {
  .benchmark <- "benchmark"
  .all <- c(.benchmark, "emission_profile")

  .x <- split(data, data[[.benchmark]])
  col <- extract_name(data, "co2_footprint")
  .by <- group_benchmark(unique(data[[.benchmark]]), .all)

  map_summarize_range(.x, col = col, .by = .by)
}
