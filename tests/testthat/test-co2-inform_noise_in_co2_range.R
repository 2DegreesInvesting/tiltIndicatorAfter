test_that("informs the expected amount of noise", {
  withr::local_options(tiltIndicatorAfter.verbose = TRUE)

  min <- 1:3
  max <- 4:6
  # Add 10% noise
  min_jitter <- -min * 1.1
  # Add 50% noise
  max_jitter <- max * 1.5
  data <- tibble(min_jitter, min, max, max_jitter)

  expect_message(inform_noise_in_co2_range(data), "10%.*50%")
})

test_that("if verbose, returns invisibly", {
  withr::local_options(tiltIndicatorAfter.verbose = TRUE)
  data <- tibble(min_jitter = 1, min = 2, max = 3, max_jitter = 4)
  suppressMessages(
    expect_invisible(inform_noise_in_co2_range(data))
  )
})

test_that("if not verbose, returns invisibly", {
  withr::local_options(tiltIndicatorAfter.verbose = FALSE)
  data <- tibble(min_jitter = 1, min = 2, max = 3, max_jitter = 4)
  suppressMessages(
    expect_invisible(inform_noise_in_co2_range(data))
  )
})


