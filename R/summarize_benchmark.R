summarize_benchmark_impl <- function(data,
                                .benchmark = "benchmark",
                                .values  = NULL,
                                .by = NULL,
                                .all = NULL) {
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
