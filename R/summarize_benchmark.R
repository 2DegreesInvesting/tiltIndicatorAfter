summarize_benchmark <- function(data) {
  .benchmark <- "benchmark"
  .all <- c(.benchmark, "emission_profile")
  .by <- group_benchmark(unique(data[[.benchmark]]), .all)

  summarize_range_of_benchmark_impl(
    data = data,
    .benchmark = .benchmark,
    .all = .all,
    .by = .by,
    .values  = extract_name(data, "co2_footprint")
  )
}

summarize_range_of_benchmark_impl <- function(data, .benchmark, .all, .by, .values) {
  .all <- .all %||% c(.benchmark, "emission_profile")
  .values <- .values %||% extract_name(data, "co2_footprint")
  .by <- .by %||% group_benchmark(unique(data[[.benchmark]]), .all)


  .x <- split(data, data[[.benchmark]])

  out <- setNames(vector("list", length = length(.x)), names(.x))
  for (i in names(.x)) {
    x_i <- .x[[i]]
    .by_i <- .by[[i]]
    out[[i]] <- summarize_range(x_i, x_i[[.values]], all_of(.by_i))
  }

  out
}
