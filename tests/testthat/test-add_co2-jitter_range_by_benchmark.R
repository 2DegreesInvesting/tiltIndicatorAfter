test_that("if min/max increases across risk categories, *jittered increases too (#214#issuecomment-2061180499)", {
  # styler: off
  data <- tribble(
    ~benchmark, ~emission_profile, ~min, ~max,
         "all",             "low",   1L,   2L,
         "all",            "high",   3L,   4L
  )
  # styler: on

  out <- jitter_range_by_benchmark(data)

  # Ensure min and max are strictly increasing
  strictly_increasing <- function(x) all(diff(x) > 0)
  stopifnot(strictly_increasing(data$min) & strictly_increasing(data$max))

  expect_true(strictly_increasing(out$min_jitter))
  expect_true(strictly_increasing(out$max_jitter))
})

test_that("if min/max increases across benchmarks, *jittered increases too (#214#issuecomment-2061180499)  ", {
  # styler: off
  data <- tribble(
    ~benchmark, ~emission_profile, ~min, ~max, ~unit,
         "all",             "low",   1L,   2L,    NA,
        "unit",             "low",   3L,   4L,  "m2"
  )
  # styler: on

  out <- jitter_range_by_benchmark(data)

  # Ensure min and max are strictly increasing
  strictly_increasing <- function(x) all(diff(x) > 0)
  stopifnot(strictly_increasing(data$min) & strictly_increasing(data$max))

  expect_true(strictly_increasing(out$min_jitter))
  expect_true(strictly_increasing(out$max_jitter))
})

test_that("adds columns `min_jitter` and `max_jitter`", {
  # styler: off
  data <- tribble(
  ~benchmark, ~emission_profile, ~min, ~max,
       "all",             "low",   1L,   1L
  )
  # styler: on

  out <- jitter_range_by_benchmark(data)
  expect_named(out, c(names(data), c("min_jitter", "max_jitter")))
})

test_that("without crucial columns errors gracefully", {
  # styler: off
  data <- tribble(
    ~benchmark, ~emission_profile, ~min, ~max,
         "all",             "low",   1L,   1L
  )
  # styler: on

  expect_error(jitter_range_by_benchmark(data |> select(-benchmark)), "benchmark.*not")
  expect_error(jitter_range_by_benchmark(data |> select(-min)), "missing.*min")
  expect_error(jitter_range_by_benchmark(data |> select(-max)), "missing.*max")
})

test_that("yields `min*` smaller than `max*`", {
  # styler: off
  data <- tribble(
    ~benchmark, ~emission_profile, ~min, ~max,
         "all",             "low",   1L,   2L
  )
  # styler: on

  out <- jitter_range_by_benchmark(data)
  expect_true(all(out$min_jitter < out$max_jitter))
})

test_that("is sensitive to `amount`", {
  # styler: off
  data <- tribble(
    ~benchmark, ~emission_profile, ~min, ~max,
    "all",             "low",   1L,   1L
  )
  # styler: on

  withr::local_seed(1)
  small <- jitter_range_by_benchmark(data, amount = 0.1)
  large <- jitter_range_by_benchmark(data, amount = 100)

  # Increase `amount` to get more extreeme min/max_jitter
  expect_true(large$min_jitter < small$min_jitter)
  expect_true(small$max_jitter < large$max_jitter)
})
