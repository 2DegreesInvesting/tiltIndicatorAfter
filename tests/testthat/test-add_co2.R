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

test_that("the `co2e*` columns are not full of `NA`s", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  out <- toy_profile_emissions_impl_output() |>
    add_co2(co2)

  product <- unnest_product(out)
  expect_false(all(is.na(product[[col_min_jitter()]])))
  expect_false(all(is.na(product[[col_max_jitter()]])))

  company <- unnest_company(out)
  expect_false(all(is.na(company[[col_min_jitter()]])))
  expect_false(all(is.na(company[[col_max_jitter()]])))
})

test_that("jittered values are grouped by unit, i.e. units with different footprint yield different jittered footprints", {
  basic <- toy_profile_emissions_impl_output()
  # From reprex 2 at https://github.com/2DegreesInvesting/tiltIndicatorAfter/pull/214#issuecomment-2086975144
  .id <- c("ironhearted_tarpan", "epitaphic_yellowhammer")
  profile <- basic |> filter(companies_id %in% .id)
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  out <- profile |> add_co2(co2, output_co2_footprint = TRUE)

  cols <- c("companies_id", "co2", "unit", "benchmark", "emission_profile", "unit", "tilt_sector", "tilt_subsector", "isic_4digit", "co2_footprint")
  pick <- out |>
    unnest_product() |>
    filter(benchmark == "unit") |>
    filter(emission_profile == "high") |>
    select(matches(cols))

  # Units with different footprint ...
  expect_false(identical(
    pull(filter(pick, unit == "kg"), "co2_footprint"),
    pull(filter(pick, unit == "m2"), "co2_footprint")
  ))

  # yield different jittered footprint
  expect_false(identical(
    pull(filter(pick, unit == "kg"), "co2e_lower"),
    pull(filter(pick, unit == "m2"), "co2e_lower")
  ))
})

test_that("characterize columns at product level", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  tilt_profile <- toy_profile_emissions_impl_output()

  out <- tilt_profile |> add_co2(co2, output_co2_footprint = TRUE)
  expect_snapshot(names(unnest_product(out)))
})

test_that("characterize columns at company level", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  tilt_profile <- toy_profile_emissions_impl_output()

  out <- tilt_profile |> add_co2(co2, output_co2_footprint = TRUE)
  expect_snapshot(names(unnest_company(out)))
})
