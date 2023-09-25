test_that("toy_sector_profile_result hasn't changed", {
  out <- toy_sector_profile_result()
  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})

test_that("toy_sector_profile_upstream_result hasn't changed", {
  out <- toy_sector_profile_upstream_result()
  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})

test_that("toy_emissions_profile_result hasn't changed", {
  out <- toy_emissions_profile_result()
  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})

test_that("toy_emissions_profile_upstream_result hasn't changed", {
  out <- toy_emissions_profile_upstream_result()
  expect_snapshot(format_minimal_snapshot(unnest_product(out)))
  expect_snapshot(format_minimal_snapshot(unnest_company(out)))
})
