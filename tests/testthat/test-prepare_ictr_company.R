# TODO: Move to test-profile_emissions_upstream.R
test_that("total number of rows for a comapny is either 1 or 3", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products())

  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = ep_companies,
    ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = small_matches_mapper,
    isic_tilt =isic_tilt_mapper
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

  expect_no_error(
    profile_emissions_upstream(
      companies,
      co2 |> modify_col("isic", as.numeric),
      europages_companies = ep_companies,
      ecoinvent_activities,
      ecoinvent_inputs = ecoinvent_inputs,
      ecoinvent_europages = small_matches_mapper,
      isic_tilt = isic_tilt_mapper
    )
  )
})
