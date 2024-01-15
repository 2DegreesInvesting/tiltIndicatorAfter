# TODO: Move to test-profile_emissions_upstream.R
test_that("total number of rows for a comapny is either 1 or 3", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_company() |>
    group_by(companies_id, benchmark) |>
    summarise(count = n())

  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("handles numeric `isic*` in `co2`", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  expect_no_error(
    profile_emissions_upstream(
      companies,
      co2 |> modify_col("isic", unquote) |> modify_col("isic", as.numeric),
      europages_companies = europages_companies,
      ecoinvent_activities = ecoinvent_activities,
      ecoinvent_inputs = ecoinvent_inputs,
      ecoinvent_europages = ecoinvent_europages,
      isic = isic_name
    )
  )
})
