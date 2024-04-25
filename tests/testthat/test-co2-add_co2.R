test_that("can output `co2_footprint` and `co2_avg`", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions_impl(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    add_co2(co2, output_co2_footprint = TRUE)

  expect_true(hasName(out |> unnest_product(), "co2_footprint"))

  # Never
  expect_false(hasName(out |> unnest_company(), "co2_footprint"))
  # Always
  expect_true(hasName(out |> unnest_company(), "co2_avg"))
  expect_true(hasName(out |> unnest_product(), "co2e_lower"))
  expect_true(hasName(out |> unnest_product(), "co2e_upper"))
  expect_true(hasName(out |> unnest_company(), "co2e_lower"))
  expect_true(hasName(out |> unnest_company(), "co2e_upper"))
})

test_that("can exclude `co2_footprint` and `co2_avg`", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions_impl(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    add_co2(co2, output_co2_footprint = FALSE)

  expect_false(hasName(out |> unnest_product(), "co2_footprint"))

  # Never
  expect_false(hasName(out |> unnest_company(), "co2_footprint"))
  # Always
  expect_true(hasName(out |> unnest_company(), "co2_avg"))
  expect_true(hasName(out |> unnest_product(), "co2e_lower"))
  expect_true(hasName(out |> unnest_product(), "co2e_upper"))
  expect_true(hasName(out |> unnest_company(), "co2e_lower"))
  expect_true(hasName(out |> unnest_company(), "co2e_upper"))
})
