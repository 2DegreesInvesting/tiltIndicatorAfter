test_that("toy_emissions_profile_output hasn't changed", {
  out <- toy_emissions_profile_output()
  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})

test_that("toy_emissions_profile_upstream_output hasn't changed", {
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
