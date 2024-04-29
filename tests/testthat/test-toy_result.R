test_that("toy_emissions_profile_output hasn't changed", {
  skip_unless_tilt_indicator_is_newer_than("0.0.0.9206")

  # FIXME: Prune #121
  skip_unless_toy_data_is_newer_than(toy_data_version())
  toy_emissions_profile_output <- function() {
    toy_output(
      emissions_profile,
      list(
        toy_emissions_profile_any_companies(),
        tiltToyData::toy_emissions_profile_products_ecoinvent()
      )
    )
  }

  out <- toy_emissions_profile_output()
  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})

test_that("toy_emissions_profile_upstream_output hasn't changed", {
  skip_unless_tilt_indicator_is_newer_than("0.0.0.9206")

  # FIXME: Prune #121
  skip_unless_toy_data_is_newer_than(toy_data_version())
  toy_emissions_profile_upstream_output <- function() {
    toy_output(
      emissions_profile_upstream,
      list(
        toy_emissions_profile_any_companies(),
        tiltToyData::toy_emissions_profile_upstream_products_ecoinvent()
      )
    )
  }

  out <- toy_emissions_profile_upstream_output()
  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})

test_that("toy_sector_profile_output hasn't changed", {
  skip_unless_tilt_indicator_is_newer_than("0.0.0.9209")

  out <- toy_sector_profile_output()

  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})

test_that("toy_sector_profile_upstream_output hasn't changed", {
  skip_unless_tilt_indicator_is_newer_than("0.0.0.9209")

  out <- toy_sector_profile_upstream_output()

  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})

test_that("toy_profile_emissions_impl_output() yields is a trustworthy shortcut", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  withr::local_seed(1)
  out1 <- profile_emissions_impl(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  withr::local_seed(1)
  out2 <- toy_profile_emissions_impl_output()

  expect_equal(out1, out2)
})
