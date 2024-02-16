set.seed(111)
create_co2_range <- function(data) {
  data |>
    summarize_range(.data[[grep("co2_footprint", names(data), value = TRUE)]],
                    .by = c("grouped_by", "risk_category")) |>
    jitter_range() |>
    select(-c("min", "max")) |>
    rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter")
}

add_co2_upper_lower <- function(data, co2_range) {
  left_join(data, co2_range, by = join_by("grouped_by", "risk_category"))
}
