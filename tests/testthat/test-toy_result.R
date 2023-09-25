test_that("toy_sector_profile_result hasn't changed", {
  out <- toy_sector_profile_result()
  expect_snapshot(str(unnest_product(out), give.attr = FALSE))
  expect_snapshot(str(unnest_company(out), give.attr = FALSE))
})

test_that("toy_sector_profile_upstream_result hasn't changed", {
  out <- toy_sector_profile_upstream_result()
  expect_snapshot(str(unnest_product(out), give.attr = FALSE))
  expect_snapshot(str(unnest_company(out), give.attr = FALSE))
})
