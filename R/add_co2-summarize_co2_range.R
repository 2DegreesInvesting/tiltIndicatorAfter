summarize_co2_range <- function(data) {
  UseMethod("summarize_co2_range")
}

#' @export
summarize_co2_range.data.frame <- function(data) {
  out <- summarize_co2_range_list(data)
  reduce(out, bind_rows)
}

summarize_co2_range_list <- function(data) {
  .all <- c(
    col_grouped_by(),
    extract_name(data, pattern_risk_category_emissions_profile_any())
  )
  # `split()` drops `NA`s in `.x`, so it makes sense to also drop them in `.by`
  .na.rm <- TRUE
  .by <- group_benchmark(unique(data[[col_grouped_by()]]), .all, na.rm = .na.rm)

  check_summarize_co2_range(data, benchmark_cols = unique(unlist(.by)))

  .x <- split(data, data[[col_grouped_by()]])
  .footprint <- extract_name(data, col_footprint())
  out <- summarize_range(.x, col = !!ensym(.footprint), .by = .by)
  out
}

#' @export
summarize_co2_range.tilt_profile <- function(data) {
  data |>
    unnest_product() |>
    summarize_co2_range()
}

check_summarize_co2_range <- function(data, benchmark_cols) {
  c(col_grouped_by(), col_footprint(), pattern_risk_category_emissions_profile_any(), benchmark_cols) |>
    walk(function(pattern) check_matches_name(data, pattern))

  if (all(is.na(data[[col_grouped_by()]]))) {
    msg <- glue("Can't handle data where all `{col_grouped_by()}` is `NA`.")
    abort(msg, class = "all_benchmark_is_na")
  }

  invisible(data)
}
