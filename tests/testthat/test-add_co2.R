test_that("at product level, different values of co2 footprint yield different values in the jittered range of co2 footprint (#214#issuecomment-2086975144)", {
  # From reprex 2 at https://github.com/2DegreesInvesting/tiltIndicatorAfter/pull/214#issuecomment-2086975144
  .id <- c("ironhearted_tarpan", "epitaphic_yellowhammer")
  profile <- toy_profile_emissions_impl_output() |>
    filter(companies_id %in% .id)
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  out <- profile |> add_co2(co2, output_co2_footprint = TRUE)

  cols <- c("companies_id", "^min", "^max", "unit", "benchmark", "emission_profile", "unit", "tilt_sector", "tilt_subsector", "isic_4digit", "co2_footprint")
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
    pull(filter(product, unit == "kg"), "min_jitter"),
    pull(filter(product, unit == "m2"), "min_jitter")
  ))
})

test_that("different risk categories yield different min and max (#214#issuecomment-2059645683)", {
  # https://github.com/2DegreesInvesting/tiltIndicatorAfter/pull/214#issuecomment-2059645683
  # > it should actually vary across risk categories (the idea is that the
  # > co2e_lower and _upper shows the lowest/highest value in each risk_category).
  # > -- Tilman
  #
  # Instead of the jittered columns, I test min/max because testing equality for
  # jittered values is impossible, and testing proximity (e.g. with
  # `dplyr::near()`) is hard. This simpler test is most likely enough to avoid
  # a regression.

  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  .benchmark <- "all"
  pick <- profile |>
    add_co2(co2, output_co2_footprint = TRUE) |>
    unnest_product() |>
    filter(benchmark %in% .benchmark) |>
    filter(emission_profile == c("high", "low")) |>
    select(matches(c("benchmark", "profile$", "co2", "min$", "max$"))) |>
    distinct()

  # different risk category has different min
  col <- col_risk_category_emissions_profile()
  low_min <- pick |>
    filter(.data[[col]] == "low") |>
    pull(min)
  high_min <- pick |>
    filter(.data[[col]] == "high") |>
    pull(min)
  expect_false(identical(low_min, high_min))

  # different risk category has different max
  low_max <- pick |>
    filter(.data[[col]] == "low") |>
    pull(max)
  high_max <- pick |>
    filter(.data[[col]] == "high") |>
    pull(max)
  expect_false(identical(low_max, high_max))

  .benchmark <- "unit"
  pick <- profile |>
    add_co2(co2, output_co2_footprint = TRUE) |>
    unnest_product() |>
    filter(benchmark %in% .benchmark) |>
    filter(emission_profile == c("high", "low")) |>
    select(matches(c("benchmark", "profile$", "co2", "min$", "max$"))) |>
    distinct()

  # different risk category has different min
  col <- col_risk_category_emissions_profile()
  low_min <- pick |>
    filter(.data[[col]] == "low") |>
    pull(min)
  high_min <- pick |>
    filter(.data[[col]] == "high") |>
    pull(min)
  expect_false(identical(low_min, high_min))

  # different risk category has different max
  low_max <- pick |>
    filter(.data[[col]] == "low") |>
    pull(max)
  high_max <- pick |>
    filter(.data[[col]] == "high") |>
    pull(max)
  expect_false(identical(low_max, high_max))
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

test_that("at company level, yields the expected number of rows with benchmark 'unit'", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()[1:20, ]

  out <- profile |> add_co2(co2, output_co2_footprint = FALSE)

  grouped_by <- "unit"
  # "high", "medium", "low", NA
  n_risk_category <- 4
  all <- c(col_benchmark(), col_risk_category_emissions_profile())
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

test_that("at product level, has co2 footprint", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2)
  expect_true(hasName(unnest_product(out), col_footprint()))
})

test_that("at company level, lacks co2 footprint", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2)
  expect_false(hasName(unnest_company(out), col_footprint()))
})

test_that("at product level, has min and max", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2)
  expect_true(hasName(unnest_product(out), "min"))
  expect_true(hasName(unnest_product(out), "max"))
})

test_that("at company level, lacks min and max", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2)
  expect_false(hasName(unnest_company(out), "min"))
  expect_false(hasName(unnest_company(out), "max"))
})

test_that("at product level, has the jittered range of co2 footprint", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2)
  expect_true(hasName(out |> unnest_product(), "min_jitter"))
  expect_true(hasName(out |> unnest_product(), "max_jitter"))
})

test_that("at product level, the jittered range of co2 footprint isn't full of `NA`s", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2)

  product <- unnest_product(out)
  expect_false(all(is.na(product[["min_jitter"]])))
  expect_false(all(is.na(product[["max_jitter"]])))
})

test_that("at company level, has the average co2 footprint", {
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  profile <- toy_profile_emissions_impl_output()

  out <- profile |> add_co2(co2)
  expect_true(hasName(out |> unnest_company(), col_footprint_mean()))
})
