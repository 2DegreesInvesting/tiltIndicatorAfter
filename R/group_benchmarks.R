group_benchmark <- function(x, all) {
  out <- lapply(x, group_benchmark_impl, all = all)
  setNames(out, x)
}

group_benchmark_impl <- function(x, all) {
  if (is.na(x)) return(x)

  # Handle "all"
  out <- all
  if (x != "all") out <- c(out, x)

  # Fix oddities
  out <- gsub("unit", "", out)
  out <- gsub("__", "_", out)
  out <- gsub("^_", "", out)

  # Add "unit" if necessary
  if (grepl("unit", x)) {
    if (grepl("input", x)) {
      out <- c(out, "input_unit")
    } else {
      out <- c(out, "unit")
    }
  }

  # Remove debris
  out <- out[!grepl("^input_$", out)]
  out <- out[nzchar(out)]

  # Turn "tilt_sector" into "tilt_subsector"
  # https://github.com/2DegreesInvesting/tiltIndicatorAfter/issues/194#issuecomment-2050573259
  # > the benchmark tilt sector groups on tilt subsector level -- Anne
  out <- gsub("tilt_sector", "tilt_subsector", out)

  out
}

# FIXME: Move to tiltIndicator?
summarize_range_by <- function(data, col, .by) {
  # FIXME? Handle `col` rather than "col"?
  # Avoiding `mutate()`. The name `.by` clashes with the argument `.by`
  data$.by <- .by
  data$grouped_across <- lapply(.by, toString)

  .l <- data |>
    rename(col = .env$col) |>
    tidyr::nest(.by = c("col", ".by")) |>
    # FIXME: Do we need these NAs?
    filter(!is.na(col))

    if (identical(nrow(.l), 0L)) {
      rlang::abort("Empty output")
  }

  purrr::pmap(.l, summarize_range) |>
    setNames(lapply(.by, toString)) |>
    tibble::enframe(name = ".by") |>
    tidyr::unnest("value")
}
