best_case_worst_case <- function(data, best_case_worst_case_x_profile) {
  product <- data |>
    unnest_product() |>
    best_case_worst_case_x_profile() |>
    polish_best_case_worst_case_emission_profile()

  company <- data |>
    unnest_company()

  tilt_profile(nest_levels(product, company))
}
