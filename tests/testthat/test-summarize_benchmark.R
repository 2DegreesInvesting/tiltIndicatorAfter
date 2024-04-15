test_that("different benchmarks output different number of rows", {
  join_quietly <- function(x, y) {
    suppressMessages(left_join(x, y, relationship = "many-to-many"))
  }

  b <- tidyr::expand_grid(
    benchmark = c("all", "unit", "unit_tilt_sector"),
    emission_profile = c("low", "medium", "high"),
    unit = c("m2", "kg")
  )
  e <- tibble::tibble(
    emission_profile = c("low", "medium", "high"),
    co2_footprint = 1:3,
  )
  ts <- tidyr::expand_grid(
    unit = c("m2", "kg"),
    tilt_sector = c("sector1", "sector2"),
    tilt_subsector = c("subsector1", "subsector2"),
  )
  data <- join_quietly(b, e) |>
    arrange(benchmark, co2_footprint, emission_profile) |>
    join_quietly(ts) |>
    mutate(isic_4digit = "'1234'")

  benchmark <- "all"
  expected <- 3
  # 3 = 3 emission_profile
  out <- summarize_benchmark_impl(data)[[benchmark]]
  expect_equal(nrow(out), expected)

  benchmark <- "unit"
  expected <- 6
  # 6 = 3 emission_profile * 2 unit
  out <- summarize_benchmark_impl(data)[[benchmark]]
  expect_equal(nrow(out), expected)

  benchmark <- "unit_tilt_sector"
  expected <- 24
  # 24 = 3 emission_profile * 2 tilt_sector * 2 tilt_subsector * 2 unit
  out <- summarize_benchmark_impl(data)[[benchmark]]
  expect_equal(nrow(out), expected)
})
