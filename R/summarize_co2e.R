summarize_co2e <- function(data,
                           .all = c("benchmark", "emission_profile")) {
  p <- data |>
    select(matches(c(
      c(
        "bench",
        "emission_profile",
        "unit",
        "isic_4digit$",
        "sector",
        "co2"
      )
    )))

  .by <- group_benchmark(p$benchmark, all = .all)

  p |>
    summarize_range_by(
      "co2_footprint",
      .by = .by
    ) |>
    jitter_range() |>
    rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter") |>
    relocate(all_of(.all), matches("co2e"), ".by") |>
    arrange(.data$benchmark)
}

join_co2e <- function(data,
                      co2e,
                      .all = c("benchmark", "emission_profile")) {
  data |>
    select(-matches("co2e")) |>
    left_join(co2e, by = .all, relationship = "many-to-many")
}

add_co2e <- function(data) {
  co2e <- data |>
    unnest_product() |>
    summarize_co2e()
  nest_levels(
    data |> unnest_product() |> join_co2e(co2e),
    data |> unnest_company() |> join_co2e(co2e)
  )
}
