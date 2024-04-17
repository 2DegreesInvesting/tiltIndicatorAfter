test_that("different benchmarks output different number of rows", {
  x <- tidyr::expand_grid(
    benchmark = c("all", "unit", "tilt_sector", "unit_tilt_sector"),
    emission_profile = c("low", "medium", "high"),
    unit = c("m2", "kg"),
    tilt_sector = c("sector1", "sector2"),
    tilt_subsector = c("subsector1", "subsector2"),
  )
  y <- tibble::tibble(
    emission_profile = c("low", "medium", "high"),
    isic_4digit = "'1234'",
    co2_footprint = 1:3,
  )
  data <- left_join(x, y, by = "emission_profile", relationship = "many-to-many")

  benchmark <- "all"
  expected <- 3
  # 3 = 3 emission_profile

  summarize_benchmark_range(data, benchmark)
  summarize_benchmark_range(data, "all")

  out <- summarize_benchmark_range_impl(data)[[benchmark]]
  expect_equal(nrow(out), expected)

  benchmark <- "unit"
  expected <- 6
  # 6 = 3 emission_profile * 2 unit
  out <- summarize_benchmark_range_impl(data)[[benchmark]]
  expect_equal(nrow(out), expected)

  benchmark <- "tilt_sector"
  expected <- 12
  # 12 = 3 emission_profile * 2 tilt_sector * 2 tilt_subsector
  out <- summarize_benchmark_range_impl(data)[[benchmark]]
  expect_equal(nrow(out), expected)

  benchmark <- "unit_tilt_sector"
  expected <- 24
  # 24 = 3 emission_profile * 2 tilt_sector * 2 tilt_subsector * 2 unit
  out <- summarize_benchmark_range_impl(data)[[benchmark]]
  expect_equal(nrow(out), expected)
})

test_that("with a simple case yields the same as `summarize_range()`", {
  # styler: off
  data <- tibble::tribble(
    ~benchmark, ~emission_profile, ~co2_footprint, ~unit, ~tilt_sector, ~tilt_subsector, ~isic_4digit,
         "all",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
         "all",          "medium",             2L,  "m2",    "sector1",    "subsector2",     "'1234'"
  )
  # styler: off

  expect_equal(
    summarize_range(data, co2_footprint, .by = c("benchmark", "emission_profile")),
    summarize_benchmark_range_impl(data)[["all"]]
  )
})
