test_that("snapshot banchmark", {
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))

  toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
  toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_csv(toy_sector_profile_companies())
  toy_europages_companies <- read_csv(toy_europages_companies())
  toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  toy_isic_name <- read_csv(toy_isic_name())

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
  out |> unnest_product() |> relocate(matches("benchmark")) |> head() |> as.data.frame()
  fmt_snap <- function(data) {
    out <- data |>
      relocate(matches("benchmark")) |>
      select(-matches("co2")) |>
      head() |>
      as.data.frame()
    out[sort(names(out))]
  }

  expect_snapshot(out |> unnest_product() |> fmt_snap())
  expect_snapshot(out |> unnest_company() |> fmt_snap())
})

test_that("outputs results both at product and company level", {
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))

  toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
  toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_csv(toy_sector_profile_companies())
  toy_europages_companies <- read_csv(toy_europages_companies())
  toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  toy_isic_name <- read_csv(toy_isic_name())

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

test_that("is sensitive to `pivot_wider`", {
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = TRUE))

  toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
  toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_csv(toy_sector_profile_companies())
  toy_europages_companies <- read_csv(toy_europages_companies())
  toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  toy_isic_name <- read_csv(toy_isic_name())

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

  long <- score_transition_risk_and_polish(
    emissions_profile,
    sector_profile
  )

  wide <- score_transition_risk_and_polish(
    emissions_profile,
    sector_profile,
    pivot_wider = TRUE
  )

  expect_equal(names(long), names(wide))
  long_cols <- long |>
    unnest_company() |>
    select(matches("emission")) |>
    ncol()
  wide_cols <- wide |>
    unnest_company() |>
    select(matches("emission")) |>
    ncol()
  expect_true(long_cols < wide_cols)
})

test_that("with `*.output_co2_footprint` unset, `pivot_wider = FALSE` yiels no error", {
  unset <- NULL
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = unset))

  toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
  toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_csv(toy_sector_profile_companies())
  toy_europages_companies <- read_csv(toy_europages_companies())
  toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  toy_isic_name <- read_csv(toy_isic_name())

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

  expect_error(
    score_transition_risk_and_polish(emissions_profile, sector_profile),
    "tiltIndicatorAfter.output_co2_footprint"
  )
})

test_that("with `*.output_co2_footprint` unset, `pivot_wider = TRUE` yiels an error", {
  unset <- NULL
  withr::local_options(list(tiltIndicatorAfter.output_co2_footprint = unset))

  toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
  toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_csv(toy_sector_profile_companies())
  toy_europages_companies <- read_csv(toy_europages_companies())
  toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  toy_isic_name <- read_csv(toy_isic_name())

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

  expect_no_error(
    score_transition_risk_and_polish(
      emissions_profile,
      sector_profile,
      pivot_wider = TRUE
    )
  )
})
