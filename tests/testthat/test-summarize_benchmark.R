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

  # (1 + 0) * 3 = 3
  # one = c("benchmark", "emission_profile") +
  # zero = c() *
  # n_risk_categories =
  # 3
  out <- summarize_benchmark_impl(data)
  expect_equal(nrow(out[["all"]]), 3)

  # (1 + 1) * 3 = 6
  # one = c("benchmark", "emission_profile") +
  # one = c("unit") *
  # n_risk_categories =
  # 6
  out <- summarize_benchmark_impl(data)
  expect_equal(nrow(out[["unit"]]), 6)

  # (1 + 2) * 3 = 12
  # one = c("benchmark", "emission_profile") +
  # two = c("unit", "tilt_sector")) *
  # n_risk_categories =
  # 12
  out <- summarize_benchmark_impl(data)
  expect_equal(nrow(out[["unit_tilt_sector"]]), 12)
})
