categorize_avg_matching_certainity <- function(x, ...) {
  case_when(
    x > 2 / 3 ~ "high",
    x > 1 / 3 & x <= 2 / 3 ~ "medium",
    x <= 1 / 3 ~ "low",
    ...
  )
}

categorize_matching_certainity <- function(x, ...) {
  case_when(
    x == "high" ~ 1,
    x == "medium" ~ 0.5,
    x == "low" ~ 0,
    ...
  )
}

add_avg_matching_certainty <- function(data, col) {
  data |>
    rename(matching_certainty = .data[[col]]) |>
    mutate(matching_certainty_num = categorize_matching_certainity(.data$matching_certainty)) |>
    mutate(avg_matching_certainty_num = mean(.data$matching_certainty_num, na.rm = TRUE), .by = c("companies_id")) |>
    mutate(avg_matching_certainty = categorize_avg_matching_certainity(.data$avg_matching_certainty_num))
}

# excluding rows with `risk_category` as NA without excluding any company which contain NAs
exclude_rows <- function(data, col) {
  ids <- data |>
    filter(all(is.na(.data[[col]])), .by = c("companies_id")) |>
    distinct(.data$companies_id)

  result <- data |>
    filter(!is.na(.data[[col]])) |>
    bind_rows(ids)
}
