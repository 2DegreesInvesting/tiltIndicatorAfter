test_that("outputs the expected columns", {
  # FIXME: This is easy to forget. Set an informative error if this is unset
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))

  toy_emissions_profile_products_ecoinvent <- read_test(toy_emissions_profile_products_ecoinvent())
  toy_emissions_profile_any_companies <- read_test(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_test(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_test(toy_sector_profile_companies())
  toy_europages_companies <- read_test(toy_europages_companies())
  toy_ecoinvent_activities <- read_test(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_test(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_test(toy_ecoinvent_inputs())
  toy_isic_name <- read_test(toy_isic_name())

  emissions_profile <- profile_emissions(
    companies = toy_emissions_profile_any_companies,
    co2 = toy_emissions_profile_products_ecoinvent,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  )

  sector_profile <- profile_sector(
    companies = toy_sector_profile_companies,
    scenarios = toy_sector_profile_any_scenarios,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  )

  out <- score_transition_risk_and_polish(emissions_profile, sector_profile)
  expect_named(out, c("companies_id", "product", "company"))
})
