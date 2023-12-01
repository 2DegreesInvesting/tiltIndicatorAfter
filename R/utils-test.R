format_minimal_snapshot <- function(data) {
  str(data, give.attr = FALSE)
}

tibble_names <- function(x, nms) {
  m <- matrix(x, ncol = length(nms), dimnames = list(NULL, nms))
  tibble::as_tibble(m)
}

arrange_and_exclude_extra_columns <- function(data) {
  data |>
    arrange(companies_id) |>
    select(-matches(extra_cols_pattern()))
}
