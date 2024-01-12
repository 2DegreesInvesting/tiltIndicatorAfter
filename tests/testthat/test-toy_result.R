test_that("toy_emissions_profile_output hasn't changed", {
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
  out <- toy_sector_profile_output()
  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})

test_that("toy_sector_profile_upstream_output hasn't changed", {
  out <- toy_sector_profile_upstream_output()
  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})
