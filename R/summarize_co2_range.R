#' @export
#' @rdname add_co2_range
summarize_co2_range <- function(data) {
  UseMethod("summarize_co2_range")
}

#' @export
summarize_co2_range.data.frame <- function(data) {
  .benchmark <- "benchmark"
  .all <- c(.benchmark, "emission_profile")
  # `split()` drops `NA`s in `.x`, so it makes sense to also drop them in `.by`
  .by <- group_benchmark(unique(data[[.benchmark]]), .all, na.rm = TRUE)
  check_summarize_co2_range(data, benchmark_cols = unique(unlist(.by)))

  .x <- split(data, data[[.benchmark]])
  col <- extract_name(data, "co2_footprint")
  out <- summarize_range(.x, col = !!ensym(col), .by = .by)
  out <- reduce(out, bind_rows)
  out
}

#' @export
summarize_co2_range.tilt_profile <- function(data) {
  product <- unnest_product(data)
  summarize_co2_range(product)
}

check_summarize_co2_range <- function(data, benchmark_cols) {
  check_col(data, "benchmark")
  check_col(data, "co2_footprint")
  walk(benchmark_cols, function(pattern) check_matches_name(data, pattern))
}
