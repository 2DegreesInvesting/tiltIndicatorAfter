group_benchmark <- function(x, all) {
  out <- lapply(x, group_benchmark_impl, all = all)
  setNames(out, x)
}

group_benchmark_impl <- function(x, all) {
  if (is.na(x)) {
    return(x)
  }

  out <- all

  # Append other values to `all`
  if (x != "all") {
    out <- c(out, x)
  }

  # Handle "unit":
  # 1. Remove it from everywhere
  out <- gsub("unit", "", out)
  # Remove debris
  out <- gsub("__", "_", out)
  out <- gsub("^_", "", out)
  # 2. Add it again wherever it's necessary
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


  # https://github.com/2DegreesInvesting/tiltIndicatorAfter/issues/194#issuecomment-2050573259
  # > the benchmark tilt sector groups on tilt subsector level -- Anne
  if (any(grepl("tilt_sector", out))) {
    # extract original match
    extracted <- grep("tilt_sector", out, value = TRUE)
    # turn "tilt_sector" into "tilt_subsector"
    out <- gsub("tilt_sector", "tilt_subsector", out)
    # re-add original match
    out <- c(out, extracted)
  }

  # After `all`, sort the other output
  other <- setdiff(out, all)
  out <- c(all, sort(other))

  out
}
