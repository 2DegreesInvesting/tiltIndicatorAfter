test_that("with products-benchmarks, outpts the expected groups", {
  product_benchmarks <- c(
    "all",
    "unit",
    "tilt_sector",
    "unit_tilt_sector",
    "isic_4digit",
    "unit_isic_4digit"
  )
  all <- c(col_grouped_by(), col_risk_category_emissions_profile())
  expect_snapshot(group_benchmark(product_benchmarks, all))
})

test_that("with inputs-benchmarks, outpts the expected groups", {
  input_benchmark <- c(
    "all",
    "input_isic_4digit",
    "input_tilt_sector",
    "input_unit",
    "input_unit_input_isic_4digit",
    "input_unit_input_tilt_sector"
  )
  all <- c(col_grouped_by(), "emission_upstream_profile")

  expect_snapshot(group_benchmark(input_benchmark, all))
})

test_that("is sensitive to `all`", {
  out <- group_benchmark("unit", all = "x")
  expect_equal(out[[1]], c("x", "unit"))

  out <- group_benchmark("unit", all = "y")
  expect_equal(out[[1]], c("y", "unit"))
})

test_that("after `all`, the output is alpha sorted", {
  benchmarks <- c(
    "all",
    "unit",
    "tilt_sector",
    "unit_tilt_sector",
    "isic_4digit",
    "unit_isic_4digit"
  )

  .all <- "z"
  out <- group_benchmark(benchmarks, all = .all)
  other <- lapply(out, setdiff, "z")
  sorted <- lapply(other, sort)

  expect_equal(other, sorted)
})

test_that("can drop missing values", {
  # Similar to `?split()`: Any missing values in f are dropped together with the
  # corresponding values of x.
  expect_equal(
    group_benchmark(c("all", NA_character_), "all", na.rm = TRUE),
    group_benchmark(c("all"), "all")
  )
})
