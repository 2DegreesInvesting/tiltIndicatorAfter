test_that("can output `co2_footprint` and `co2_avg`", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  tilt_profile <- toy_profile_emissions_impl_output()

  out <- tilt_profile |> add_co2(co2, output_co2_footprint = TRUE)

  expect_true(hasName(out |> unnest_product(), col_footprint()))

  # Never
  expect_false(hasName(out |> unnest_company(), col_footprint()))
  # Always
  expect_true(hasName(out |> unnest_company(), col_footprint_mean()))
  expect_true(hasName(out |> unnest_product(), col_min_jitter()))
  expect_true(hasName(out |> unnest_product(), col_max_jitter()))
  expect_true(hasName(out |> unnest_company(), col_min_jitter()))
  expect_true(hasName(out |> unnest_company(), col_max_jitter()))
})

test_that("can exclude `co2_footprint` and `co2_avg`", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  tilt_profile <- toy_profile_emissions_impl_output()

  out <- tilt_profile |> add_co2(co2, output_co2_footprint = FALSE)

  expect_false(hasName(out |> unnest_product(), col_footprint()))

  # Never
  expect_false(hasName(out |> unnest_company(), col_footprint()))
  # Always
  expect_true(hasName(out |> unnest_company(), col_footprint_mean()))
  expect_true(hasName(out |> unnest_product(), col_min_jitter()))
  expect_true(hasName(out |> unnest_product(), col_max_jitter()))
  expect_true(hasName(out |> unnest_company(), col_min_jitter()))
  expect_true(hasName(out |> unnest_company(), col_max_jitter()))
})
