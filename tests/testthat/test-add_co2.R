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

test_that("with 'all' yields the expected number of rows", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  tilt_profile <- toy_profile_emissions_impl_output()[1:2, ]

  out <- tilt_profile |> add_co2(co2, output_co2_footprint = FALSE)

  grouped_by <- "all"
  # "high", "medium", "low", NA
  n_risk_category <- 4
  expected <- n_risk_category

  n_row <- out |>
    unnest_company() |>
    filter(companies_id %in% companies_id[[1]]) |>
    filter(benchmark == grouped_by) |>
    nrow()

  expect_equal(n_row, expected)
})

test_that("with 'unit' yields the expected number of rows", {
  skip("FIXME see https://github.com/2DegreesInvesting/tiltIndicatorAfter/pull/214#issuecomment-2083605852")

  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  tilt_profile <- toy_profile_emissions_impl_output()[1:20, ]

  out <- tilt_profile |> add_co2(co2, output_co2_footprint = FALSE)

  grouped_by <- "unit"
  # "high", "medium", "low", NA
  n_risk_category <- 4
  all <- c(col_grouped_by(), col_risk_category_emissions_profile())
  groups <- group_benchmark("unit", all)[[1]]
  n_unit <- out |>
    unnest_product() |>
    filter(companies_id %in% companies_id[[1]]) |>
    filter(benchmark == grouped_by) |>
    select(all_of(groups)) |>
    distinct() |>
    nrow()
  expected <- n_risk_category * n_unit

  n_row <- out |>
    unnest_company() |>
    filter(companies_id %in% companies_id[[1]]) |>
    filter(benchmark == grouped_by) |>
    nrow()

  expect_equal(n_row, expected)
})
