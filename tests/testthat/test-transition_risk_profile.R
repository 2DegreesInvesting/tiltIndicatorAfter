test_that("yields a 'tilt_profile'", {
  set.seed(123)
  restore <- options(list(
    readr.show_col_types = FALSE,
    tiltIndicatorAfter.output_co2_footprint = TRUE
  ))

  toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent()) |>
    filter(activity_uuid_product_uuid != "76269c17-78d6-420b-991a-aa38c51b45b7")
  toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_csv(toy_sector_profile_companies()) |>
    filter(activity_uuid_product_uuid == "76269c17-78d6-420b-991a-aa38c51b45b7")
  toy_europages_companies <- read_csv(toy_europages_companies())
  toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  toy_isic_name <- read_csv(toy_isic_name())
  toy_all_activities_scenario_sectors <- read_csv(toy_all_activities_scenario_sectors()) |>
    filter(activity_uuid_product_uuid == "76269c17-78d6-420b-991a-aa38c51b45b7")

  toy_emissions_profile <- profile_emissions(
    companies = toy_emissions_profile_any_companies,
    co2 = toy_emissions_profile_products_ecoinvent,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  )
  toy_sector_profile <- profile_sector(
    companies = toy_sector_profile_companies,
    scenarios = toy_sector_profile_any_scenarios,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  )

  output <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = FALSE
  )

  expect_s3_class(output, "tilt_profile")
})


test_that("outputs `NA` transition risk category for `NA` transition risk score ", {
  set.seed(123)
  restore <- options(list(
    readr.show_col_types = FALSE,
    tiltIndicatorAfter.output_co2_footprint = TRUE
  ))

  toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent()) |>
    filter(activity_uuid_product_uuid != "76269c17-78d6-420b-991a-aa38c51b45b7")
  toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_csv(toy_sector_profile_companies()) |>
    filter(activity_uuid_product_uuid == "76269c17-78d6-420b-991a-aa38c51b45b7")
  toy_europages_companies <- read_csv(toy_europages_companies())
  toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  toy_isic_name <- read_csv(toy_isic_name())
  toy_all_activities_scenario_sectors <- read_csv(toy_all_activities_scenario_sectors()) |>
    filter(activity_uuid_product_uuid == "76269c17-78d6-420b-991a-aa38c51b45b7")

  toy_emissions_profile <- profile_emissions(
    companies = toy_emissions_profile_any_companies,
    co2 = toy_emissions_profile_products_ecoinvent,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  )
  toy_sector_profile <- profile_sector(
    companies = toy_sector_profile_companies,
    scenarios = toy_sector_profile_any_scenarios,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  )

  output <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = FALSE
  ) |>
    unnest_product() |>
    filter(activity_uuid_product_uuid == "76269c17-78d6-420b-991a-aa38c51b45b7")

  # Transition risk score is `NA` for uuid "76269c17-78d6-420b-991a-aa38c51b45b7"
  expect_true(is.na(unique(output$transition_risk_score)))
  # `transition_risk_category` is `NA` for `NA` transition risk score
  expect_true(is.na(unique(output$transition_risk_category)))
})

test_that("outputs columns `transition_risk_category_share` and `transition_risk_category` at company level", {
  toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent()) |>
    filter(activity_uuid_product_uuid == "76269c17-78d6-420b-991a-aa38c51b45b7")
  toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_csv(toy_sector_profile_companies()) |>
    filter(activity_uuid_product_uuid == "76269c17-78d6-420b-991a-aa38c51b45b7")
  toy_europages_companies <- read_csv(toy_europages_companies())
  toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  toy_isic_name <- read_csv(toy_isic_name())
  toy_all_activities_scenario_sectors <- read_csv(toy_all_activities_scenario_sectors()) |>
    filter(activity_uuid_product_uuid == "76269c17-78d6-420b-991a-aa38c51b45b7")

  toy_emissions_profile <- profile_emissions(
    companies = toy_emissions_profile_any_companies,
    co2 = toy_emissions_profile_products_ecoinvent,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  )
  toy_sector_profile <- profile_sector(
    companies = toy_sector_profile_companies,
    scenarios = toy_sector_profile_any_scenarios,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  )

  company_level_output <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = FALSE
  ) |>
    unnest_company()

  expected_cols <- c("transition_risk_category_share", "transition_risk_category")

  expect_true(all(unique(expected_cols) %in% names(company_level_output)))
})