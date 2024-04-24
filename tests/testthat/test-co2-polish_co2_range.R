test_that("yields the expected names", {
  data <- tibble(min = 1, max = 2, min_jitter = 0, max_jitter = 4)

  out <- polish_co2_range(data)

  expected <- c("co2e_lower", "co2e_upper")
  expect_named(out, expected)
})

test_that("without crucial columns errors gracefully", {
  data <- tibble(min = 1, max = 2, min_jitter = 0, max_jitter = 4)

  expect_error(polish_co2_range(select(data, -min)), "min.*doesn't exist")
  expect_error(polish_co2_range(select(data, -max)), "max.*doesn't exist")
  expect_error(polish_co2_range(select(data, -min_jitter)), "min_jitter")
  expect_error(polish_co2_range(select(data, -max_jitter)), "max_jitter")
})
