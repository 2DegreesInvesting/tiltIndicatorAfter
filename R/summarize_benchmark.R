draft_summarize_benchmark_range <- function(data) {
  .benchmark <- "benchmark"
  .all <- c(.benchmark, "emission_profile")
  .by <- group_benchmark(unique(data[[.benchmark]]), .all)

  summarize_values_range_in_groups_by(
    data = data,
    .values = extract_name(data, "co2_footprint"),
    .groups = .benchmark,
    .by = .by
  )
}

summarize_values_range_in_groups_by <- function(data, .values, .groups, .by) {
  .x <- split(data, data[[.groups]])

  out <- vector("list", length = length(.x))
  out <- setNames(out, names(.x))

  for (i in names(.x)) {
    out[[i]] <- summarize_range(
      data = .x[[i]],
      col = .x[[i]][[.values]],
      .by = all_of(.by[[i]])
    )
  }

  out
}
