test_that("yields a 'tilt_profile'", {
  restore <- options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))
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


test_that("outputs `NA` transition risk category for `NA` transition risk score at product level", {
  restore <- options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))
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

test_that("outputs `NA` in `avg_transition_risk_best_case` and `avg_transition_risk_worst_case` for `NA` at company level if `transition_risk_score` and `transition_risk_category` are `NA` at product level", {
  restore <- options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))
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

  product_level_output <- output |>
    unnest_product()

  company_level_output <- output |>
    unnest_company()

  # `avg_transition_risk_equal_weight` and `transition_risk_category` are `NA`at product level
  expect_true(is.na(unique(product_level_output$transition_risk_score)))
  expect_true(is.na(unique(product_level_output$transition_risk_category)))
  # `avg_transition_risk_best_case` and `avg_transition_risk_worst_case` are `NA` are `NA` at company level
  expect_true(is.na(unique(company_level_output$avg_transition_risk_best_case)))
  expect_true(is.na(unique(company_level_output$avg_transition_risk_worst_case)))
})

test_that("is sensitive to `pivot_wider`", {
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))

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

  long <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios
  )

  wide <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = TRUE
  )

  expect_equal(names(long), names(wide))

  #Emissions profile
  long_emission_cols <- long |>
    unnest_company() |>
    select(matches("emission")) |>
    ncol()
  wide_emission_cols <- wide |>
    unnest_company() |>
    select(matches("emission")) |>
    ncol()
  expect_true(long_emission_cols < wide_emission_cols)

  #Sector profile
  long_sector_cols <- long |>
    unnest_company() |>
    select(matches("sector")) |>
    ncol()
  wide_sector_cols <- wide |>
    unnest_company() |>
    select(matches("sector")) |>
    ncol()
  expect_true(long_sector_cols < wide_sector_cols)

  #Transition risk profile
  long_transition_risk_cols <- long |>
    unnest_company() |>
    select(matches("transition_risk")) |>
    ncol()
  wide_transition_risk_cols <- wide |>
    unnest_company() |>
    select(matches("transition_risk")) |>
    ncol()
  expect_true(long_transition_risk_cols < wide_transition_risk_cols)
})

test_that("with `*.output_co2_footprint` unset, `pivot_wider = TRUE` yields no error", {
  unset <- NULL
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = unset))

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

  expect_no_error(
    transition_risk_profile(
      emissions_profile = toy_emissions_profile,
      sector_profile = toy_sector_profile,
      co2 = toy_emissions_profile_products_ecoinvent,
      all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
      scenarios = toy_sector_profile_any_scenarios,
      pivot_wider = TRUE
    )
  )
})

test_that("doesn't output `co2_footprint` at product level and `co2_avg` at company level if `*.output_co2_footprint` unset", {
  unset <- NULL
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = unset))

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

  long <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios
  )

  wide <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = TRUE
  )

  expect_false("co2_footprint" %in% names(unnest_product(long)))
  expect_false("co2_avg" %in% names(unnest_company(long)))
  expect_false("co2_footprint" %in% names(unnest_product(wide)))
  expect_false("co2_avg" %in% names(unnest_company(wide)))
})


test_that("outputs `co2_footprint` at product level and `co2_avg` at company level if `*.output_co2_footprint = TRUE`", {
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))

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

  long <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios
  )

  wide <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = TRUE
  )

  expect_true("co2_footprint" %in% names(unnest_product(long)))
  expect_true("co2_avg" %in% names(unnest_company(long)))
  expect_true("co2_footprint" %in% names(unnest_product(wide)))
  expect_true("co2_avg" %in% names(unnest_company(wide)))
})

test_that("with `pivot_wider = TRUE`, at company level the `emission*` column are of type double", {
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))

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

  type <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = TRUE
  ) |>
    unnest_company() |>
    select(matches("emission")) |>
    lapply(typeof) |>
    unlist() |>
    unique()
  expect_equal(type, "double")
})

test_that("the output at product level has all the new required columns (#189)", {
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

  product <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = FALSE
  ) |>
    unnest_product()

  expect_true(any(matches_name(product, "postcode")))
  expect_true(any(matches_name(product, "address")))
  expect_true(any(matches_name(product, "min_headcount")))
  expect_true(any(matches_name(product, "max_headcount")))
  expect_true(any(matches_name(product, "emissions_profile_best_case")))
  expect_true(any(matches_name(product, "emissions_profile_worst_case")))
  expect_true(any(matches_name(product, "transition_risk_profile_best_case")))
  expect_true(any(matches_name(product, "transition_risk_profile_worst_case")))
  expect_true(any(matches_name(product, "isic_4digit")))
  expect_true(any(matches_name(product, "matching_certainty")))
  expect_true(any(matches_name(product, "company_name")))
  expect_true(any(matches_name(product, "emissions_profile_equal_weight")))
  expect_true(any(matches_name(product, "amount_of_distinct_products_matched")))
})

test_that("the output at company level has has all the new required columns (#189, #290)", {
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

  company <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = TRUE
  ) |>
    unnest_company()

  expect_true(any(matches_name(company, "postcode")))
  expect_true(any(matches_name(company, "address")))
  expect_true(any(matches_name(company, "min_headcount")))
  expect_true(any(matches_name(company, "max_headcount")))
  expect_true(any(matches_name(company, "company")))
  expect_true(any(matches_name(company, "avg_profile_ranking_best_case")))
  expect_true(any(matches_name(company, "avg_profile_ranking_worst_case")))
  expect_true(any(matches_name(company, "avg_reduction_targets_best_case")))
  expect_true(any(matches_name(company, "avg_reduction_targets_worst_case")))
})

test_that("At product level, when either `sector_profile` is NA or `emission_profile` is NA, tilt and isic sectors are not NA", {
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

  output_product <- transition_risk_profile(
    emissions_profile = toy_emissions_profile,
    sector_profile = toy_sector_profile,
    co2 = toy_emissions_profile_products_ecoinvent,
    all_activities_scenario_sectors = toy_all_activities_scenario_sectors,
    scenarios = toy_sector_profile_any_scenarios,
    pivot_wider = TRUE
  ) |> unnest_product()

  # when `sector_profile` is NA then, tilt and isic sectors are not NA
  out_sector_na <- filter(output_product, is.na(sector_profile))
  expect_true(nrow(filter(out_sector_na, is.na(out_sector_na$tilt_sector))) == 0)
  expect_true(nrow(filter(out_sector_na, is.na(out_sector_na$tilt_subsector))) == 0)
  expect_true(nrow(filter(out_sector_na, is.na(out_sector_na$isic_4digit))) == 0)

  # when `emission_profile` is NA then, tilt and isic sectors are not NA
  out_emissions_na <- filter(output_product, is.na(emission_profile))
  expect_true(nrow(filter(out_emissions_na, is.na(out_emissions_na$tilt_sector))) == 0)
  expect_true(nrow(filter(out_emissions_na, is.na(out_emissions_na$tilt_subsector))) == 0)
  expect_true(nrow(filter(out_emissions_na, is.na(out_emissions_na$isic_4digit))) == 0)
})
