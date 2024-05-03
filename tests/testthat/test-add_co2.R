test_that("at product level, characterize columns ", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2, output_co2_footprint = TRUE)
  expect_snapshot(names(unnest_product(out)))
})

test_that("at company level, characterize columns", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2, output_co2_footprint = TRUE)
  expect_snapshot(names(unnest_company(out)))
})

test_that("at product level, the co2 footprint", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2, output_co2_footprint = TRUE)
  expect_true(hasName(out |> unnest_product(), col_footprint()))

  out <- profile |> add_co2(co2, output_co2_footprint = FALSE)
  expect_false(hasName(out |> unnest_product(), col_footprint()))
})

test_that("at company level, the co2 footprint is optionally included", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2, output_co2_footprint = FALSE)
  expect_false(hasName(out |> unnest_company(), col_footprint()))
  out <- profile |> add_co2(co2, output_co2_footprint = TRUE)
  expect_false(hasName(out |> unnest_company(), col_footprint()))
})

test_that("at product level, the jittered range of co2 footprint can be included", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2, output_co2_footprint = TRUE)
  expect_true(hasName(out |> unnest_product(), col_min_jitter()))
  expect_true(hasName(out |> unnest_product(), col_max_jitter()))

  out <- profile |> add_co2(co2, output_co2_footprint = FALSE)
  expect_true(hasName(out |> unnest_product(), col_min_jitter()))
  expect_true(hasName(out |> unnest_product(), col_max_jitter()))
})

test_that("at product level, the jittered range of co2 footprint isn't full of `NA`s", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2)

  product <- unnest_product(out)
  expect_false(all(is.na(product[[col_min_jitter()]])))
  expect_false(all(is.na(product[[col_max_jitter()]])))
})

test_that("at company level, the average co2 footprint is always included", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2, output_co2_footprint = FALSE)
  expect_true(hasName(out |> unnest_company(), col_footprint_mean()))
  out <- profile |> add_co2(co2, output_co2_footprint = TRUE)
  expect_true(hasName(out |> unnest_company(), col_footprint_mean()))
})

test_that("at company level, yields the expected number of rows with benchmark 'all' ", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()[1:2, ]

  out <- profile |> add_co2(co2, output_co2_footprint = FALSE)

  grouped_by <- "all"
  # "high", "medium", "low", NA
  n_risk_category <- 4
  expected <- n_risk_category

  company <- out |>
    unnest_company() |>
    filter(companies_id %in% companies_id[[1]]) |>
    filter(benchmark == grouped_by)

  expect_equal(nrow(company), expected)
})

test_that("yields the expected number of rows with benchmark 'unit'", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()[1:20, ]

  out <- profile |> add_co2(co2, output_co2_footprint = FALSE)

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

  company <- out |>
    unnest_company() |>
    filter(companies_id %in% companies_id[[1]]) |>
    filter(benchmark == grouped_by)

  expect_equal(nrow(company), expected)
})

test_that("at product level, different values of co2 footprint yield different values in the jittered range of co2 footprint", {
  # From reprex 2 at https://github.com/2DegreesInvesting/tiltIndicatorAfter/pull/214#issuecomment-2086975144
  .id <- c("ironhearted_tarpan", "epitaphic_yellowhammer")
  profile <- toy_profile_emissions_impl_output() |>
    filter(companies_id %in% .id)
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  out <- profile |> add_co2(co2, output_co2_footprint = TRUE)

  cols <- c("companies_id", "co2", "unit", "benchmark", "emission_profile", "unit", "tilt_sector", "tilt_subsector", "isic_4digit", "co2_footprint")
  product <- out |>
    unnest_product() |>
    filter(benchmark == "unit") |>
    filter(emission_profile == "high") |>
    select(matches(cols))

  # Units with different footprint ...
  expect_false(identical(
    pull(filter(product, unit == "kg"), "co2_footprint"),
    pull(filter(product, unit == "m2"), "co2_footprint")
  ))

  # yield different jittered footprint
  expect_false(identical(
    pull(filter(product, unit == "kg"), "co2e_lower"),
    pull(filter(product, unit == "m2"), "co2e_lower")
  ))
})
