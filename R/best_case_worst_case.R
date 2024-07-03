best_case_worst_case <- function(data) {
  product <- data |>
    unnest_product() |>
    best_case_worst_case_emission_profile() |>
    polish_best_case_worst_case() |>
    polish_best_case_worst_case_emissions_profile()

  company <- data |>
    unnest_company()

  tilt_profile(nest_levels(product, company))
}
