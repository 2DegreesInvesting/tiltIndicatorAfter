test_that("yields the expected names", {
  data <- tibble(min = 1, max = 2, min_jitter = 0, max_jitter = 4)

  out <- polish_co2_range(data)

  expected <- c(col_min_jitter(), col_max_jitter())
  expect_named(out, expected)
})

test_that("outputs co2e* by default", {
  data <- tibble(min = 1, max = 2, min_jitter = 0, max_jitter = 4)

  expect_named(polish_co2_range(data), c(col_min_jitter(), col_max_jitter()))
})

test_that("can output `min`, `max`", {
  data <- tibble(min = 1, max = 2, min_jitter = 0, max_jitter = 4)

  out <- polish_co2_range(data, output_min_max = TRUE)
  expect_true(hasName(out, "min"))
  expect_true(hasName(out, "max"))
})

test_that("can output `output_co2_footprint`", {
  data <- tibble(min = 1, max = 2, min_jitter = 0, max_jitter = 4)

    expect_named(
      polish_co2_range(data, output_co2_footprint = TRUE),
      c(col_min_jitter(), col_max_jitter())
    )
})
