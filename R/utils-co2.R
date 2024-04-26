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
