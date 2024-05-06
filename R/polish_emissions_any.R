polish_emissions_any <- function(data,
                                 ...,
                                 output_min_max = FALSE,
                                 output_co2_footprint = FALSE) {
  product <- data |>
    unnest_product() |>
    polish_emissions_any_impl(
      output_min_max = output_min_max,
      output_co2_footprint = output_co2_footprint
    )

  company <- data |>
    unnest_company()

  tilt_profile(nest_levels(product, company))
}

polish_emissions_any_impl <- function(data,
                                      ...,
                                      output_min_max = FALSE,
                                      output_co2_footprint = FALSE) {
  out <- data |> rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter")

  if (!output_min_max) {
    out <- out |> exclude(c("^min$", "^max$"))
  }

  if (!output_co2_footprint) {
    out <- out |> exclude(col_footprint())
  }

  out
}
