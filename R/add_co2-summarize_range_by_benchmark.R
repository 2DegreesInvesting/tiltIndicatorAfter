summarize_range_by_benchmark <- function(data) {
  out <- split_summarize_range_by_benchmark(data)
  reduce(out, bind_rows)
}

split_summarize_range_by_benchmark <- function(data) {
  .all <- c(
    col_benchmark(),
    extract_name(data, pattern_risk_category_emissions_profile_any())
  )
  # `split()` drops `NA`s in `.x`, so it makes sense to also drop them in `.by`
  .na.rm <- TRUE
  .by <- group_benchmark(unique(data[[col_benchmark()]]), .all, na.rm = .na.rm)

  check_summarize_range_by_benchmark(data, benchmark_cols = unique(unlist(.by)))

  .x <- split(data, data[[col_benchmark()]])
  .footprint <- extract_name(data, col_footprint())
  out <- summarize_range(.x, col = !!ensym(.footprint), .by = .by)
  out
}

check_summarize_range_by_benchmark <- function(data, benchmark_cols) {
  c(col_benchmark(), col_footprint(), pattern_risk_category_emissions_profile_any(), benchmark_cols) |>
    walk(function(pattern) check_matches_name(data, pattern))

  if (all(is.na(data[[col_benchmark()]]))) {
    msg <- glue("Can't handle data where all `{col_benchmark()}` is `NA`.")
    abort(msg, class = "all_benchmark_is_na")
  }

  invisible(data)
}
