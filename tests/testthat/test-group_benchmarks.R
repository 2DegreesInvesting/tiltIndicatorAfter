test_that("with products-benchmarks, outpts the expected groups", {
  withr::local_options(width = 500)

  product_benchmarks <- c(
    "all",
    "unit",
    "tilt_sector",
    "unit_tilt_sector",
    "isic_4digit",
    "unit_isic_4digit"
  )
  all <- c("benchmark", "emission_profile")
  expect_snapshot(group_benchmark(product_benchmarks, all))
})

test_that("with inputs-benchmarks, outpts the expected groups", {
  withr::local_options(width = 500)

  input_benchmark <- c(
    "all",
    "input_unit",
    "input_tilt_sector",
    "input_unit_tilt_sector",
    "input_isic_4digit",
    "input_unit_isic_4digit"
  )
  all <- c("benchmark", "emission_upstream_profile")
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

# MAYBE DELETE
test_that("hangles missing values", {
  out <- group_benchmark(NA_character_, "all")
  expect_equal(out[[1]], NA_character_)
  expect_equal(names(out), NA_character_)
})

# DELETE

test_that("with tilt_sector the output includes tilt_sector", {
  out <- group_benchmark("tilt_sector", "all")
  expect_true("tilt_sector" %in% out[[1]])
})

test_that("with tilt_sector the output includes tilt_subsector", {
  out <- group_benchmark("tilt_sector", "all")
  expect_true("tilt_subsector" %in% out[[1]])
})

test_that("with input_tilt_sector the output includes input_tilt_sector", {
  out <- group_benchmark("input_tilt_sector", "all")
  expect_true("input_tilt_sector" %in% out[[1]])
})

test_that("with input_tilt_sector the output includes input_tilt_subsector", {
  out <- group_benchmark("input_tilt_sector", "all")
  expect_true("input_tilt_subsector" %in% out[[1]])
})
test_that("with unit_tilt_sector the output includes tilt_sector", {
  out <- group_benchmark("unit_tilt_sector", "all")
  expect_true("tilt_sector" %in% out[[1]])
})

test_that("with unit_tilt_sector the output includes tilt_subsector", {
  out <- group_benchmark("unit_tilt_sector", "all")
  expect_true("tilt_subsector" %in% out[[1]])
})
