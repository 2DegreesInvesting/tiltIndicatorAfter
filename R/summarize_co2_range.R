summarize_co2_range <- function(data) {
  .benchmark <- "benchmark"
  .all <- c(.benchmark, "emission_profile")

  .x <- split(data, data[[.benchmark]])
  col <- extract_name(data, "co2_footprint")
  .by <- group_benchmark(unique(data[[.benchmark]]), .all)

  out <- map_summarize_range(.x, col = col, .by = .by)
  reduce(out, bind_rows)
}

jitter_co2_range <- function(data, amount = 2) {
  data |>
    group_by(benchmark) |>
    dplyr::group_split() |>
    lapply(jitter_range, amount = amount) |>
    purrr::reduce(bind_rows)
}

polish_co2_range <- function(data, ...) {
  data |>
    rename(co2_lower = "min_jitter", co2_upper = "max_jitter") |>
    select(-c("min", "max"))
}
