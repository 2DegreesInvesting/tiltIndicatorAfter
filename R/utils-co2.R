create_co2_range <- function(data, amount = option_jitter_amount()) {
  col <- extract_name(data, "co2_footprint")
  .by <- c("grouped_by", "risk_category")

  out <- data |>
    summarize_range(!!ensym(col), .by = all_of(.by)) |>
    jitter_range(amount = amount)

  out |> inform_noise_in_co2_range()

  out <- out |> rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter")

  if (option_output_min_max()) {
    return(out)
  }

  out |> select(-c("min", "max"))
}

add_co2_upper_lower <- function(data, co2_range) {
  left_join(data, co2_range, by = join_by("grouped_by", "risk_category"))
}

optionally_output_co2_footprint <- function(out, co2_footprint) {
  if (!option_output_co2_footprint()) {
    return(out)
  }

  product <- out |>
    unnest_product() |>
    left_join(
      co2_footprint,
      by = "activity_uuid_product_uuid"
    )

  by <- c("companies_id", "benchmark")
  co2_avg <- product |>
    select(all_of(c(by, "co2_footprint"))) |>
    summarise(
      co2_avg = round(mean(co2_footprint, na.rm = TRUE), 3),
      .by = all_of(by)
    )
  company <- out |>
    unnest_company() |>
    left_join(co2_avg, by = by, relationship = "many-to-many")

  nest_levels(product, company)
}
