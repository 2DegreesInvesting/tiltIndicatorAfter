# styler: off
data <- tibble::tribble(
          ~benchmark, ~emission_profile, ~unit, ~co2_footprint, ~tilt_sector, ~tilt_subsector, ~isic_4digit,
               "all",             "low",  "m2",             1L,    "sector1",    "subsector1",     "'1234'",
               "all",             "low",  "m2",             1L,    "sector1",    "subsector2",     "'1234'",
               "all",             "low",  "m2",             1L,    "sector2",    "subsector1",     "'1234'",
               "all",             "low",  "m2",             1L,    "sector2",    "subsector2",     "'1234'",
               "all",             "low",  "kg",             1L,    "sector1",    "subsector1",     "'1234'",
               "all",             "low",  "kg",             1L,    "sector1",    "subsector2",     "'1234'",
               "all",             "low",  "kg",             1L,    "sector2",    "subsector1",     "'1234'",
               "all",             "low",  "kg",             1L,    "sector2",    "subsector2",     "'1234'",
               "all",          "medium",  "m2",             2L,    "sector1",    "subsector1",     "'1234'",
               "all",          "medium",  "m2",             2L,    "sector1",    "subsector2",     "'1234'",
               "all",          "medium",  "m2",             2L,    "sector2",    "subsector1",     "'1234'",
               "all",          "medium",  "m2",             2L,    "sector2",    "subsector2",     "'1234'",
               "all",          "medium",  "kg",             2L,    "sector1",    "subsector1",     "'1234'",
               "all",          "medium",  "kg",             2L,    "sector1",    "subsector2",     "'1234'",
               "all",          "medium",  "kg",             2L,    "sector2",    "subsector1",     "'1234'",
               "all",          "medium",  "kg",             2L,    "sector2",    "subsector2",     "'1234'",
               "all",            "high",  "m2",             3L,    "sector1",    "subsector1",     "'1234'",
               "all",            "high",  "m2",             3L,    "sector1",    "subsector2",     "'1234'",
               "all",            "high",  "m2",             3L,    "sector2",    "subsector1",     "'1234'",
               "all",            "high",  "m2",             3L,    "sector2",    "subsector2",     "'1234'",
               "all",            "high",  "kg",             3L,    "sector1",    "subsector1",     "'1234'",
               "all",            "high",  "kg",             3L,    "sector1",    "subsector2",     "'1234'",
               "all",            "high",  "kg",             3L,    "sector2",    "subsector1",     "'1234'",
               "all",            "high",  "kg",             3L,    "sector2",    "subsector2",     "'1234'",
              "unit",             "low",  "m2",             1L,    "sector1",    "subsector1",     "'1234'",
              "unit",             "low",  "m2",             1L,    "sector1",    "subsector2",     "'1234'",
              "unit",             "low",  "m2",             1L,    "sector2",    "subsector1",     "'1234'",
              "unit",             "low",  "m2",             1L,    "sector2",    "subsector2",     "'1234'",
              "unit",             "low",  "kg",             1L,    "sector1",    "subsector1",     "'1234'",
              "unit",             "low",  "kg",             1L,    "sector1",    "subsector2",     "'1234'",
              "unit",             "low",  "kg",             1L,    "sector2",    "subsector1",     "'1234'",
              "unit",             "low",  "kg",             1L,    "sector2",    "subsector2",     "'1234'",
              "unit",          "medium",  "m2",             2L,    "sector1",    "subsector1",     "'1234'",
              "unit",          "medium",  "m2",             2L,    "sector1",    "subsector2",     "'1234'",
              "unit",          "medium",  "m2",             2L,    "sector2",    "subsector1",     "'1234'",
              "unit",          "medium",  "m2",             2L,    "sector2",    "subsector2",     "'1234'",
              "unit",          "medium",  "kg",             2L,    "sector1",    "subsector1",     "'1234'",
              "unit",          "medium",  "kg",             2L,    "sector1",    "subsector2",     "'1234'",
              "unit",          "medium",  "kg",             2L,    "sector2",    "subsector1",     "'1234'",
              "unit",          "medium",  "kg",             2L,    "sector2",    "subsector2",     "'1234'",
              "unit",            "high",  "m2",             3L,    "sector1",    "subsector1",     "'1234'",
              "unit",            "high",  "m2",             3L,    "sector1",    "subsector2",     "'1234'",
              "unit",            "high",  "m2",             3L,    "sector2",    "subsector1",     "'1234'",
              "unit",            "high",  "m2",             3L,    "sector2",    "subsector2",     "'1234'",
              "unit",            "high",  "kg",             3L,    "sector1",    "subsector1",     "'1234'",
              "unit",            "high",  "kg",             3L,    "sector1",    "subsector2",     "'1234'",
              "unit",            "high",  "kg",             3L,    "sector2",    "subsector1",     "'1234'",
              "unit",            "high",  "kg",             3L,    "sector2",    "subsector2",     "'1234'",
  "unit_tilt_sector",             "low",  "m2",             1L,    "sector1",    "subsector1",     "'1234'",
  "unit_tilt_sector",             "low",  "m2",             1L,    "sector1",    "subsector2",     "'1234'",
  "unit_tilt_sector",             "low",  "m2",             1L,    "sector2",    "subsector1",     "'1234'",
  "unit_tilt_sector",             "low",  "m2",             1L,    "sector2",    "subsector2",     "'1234'",
  "unit_tilt_sector",             "low",  "kg",             1L,    "sector1",    "subsector1",     "'1234'",
  "unit_tilt_sector",             "low",  "kg",             1L,    "sector1",    "subsector2",     "'1234'",
  "unit_tilt_sector",             "low",  "kg",             1L,    "sector2",    "subsector1",     "'1234'",
  "unit_tilt_sector",             "low",  "kg",             1L,    "sector2",    "subsector2",     "'1234'",
  "unit_tilt_sector",          "medium",  "m2",             2L,    "sector1",    "subsector1",     "'1234'",
  "unit_tilt_sector",          "medium",  "m2",             2L,    "sector1",    "subsector2",     "'1234'",
  "unit_tilt_sector",          "medium",  "m2",             2L,    "sector2",    "subsector1",     "'1234'",
  "unit_tilt_sector",          "medium",  "m2",             2L,    "sector2",    "subsector2",     "'1234'",
  "unit_tilt_sector",          "medium",  "kg",             2L,    "sector1",    "subsector1",     "'1234'",
  "unit_tilt_sector",          "medium",  "kg",             2L,    "sector1",    "subsector2",     "'1234'",
  "unit_tilt_sector",          "medium",  "kg",             2L,    "sector2",    "subsector1",     "'1234'",
  "unit_tilt_sector",          "medium",  "kg",             2L,    "sector2",    "subsector2",     "'1234'",
  "unit_tilt_sector",            "high",  "m2",             3L,    "sector1",    "subsector1",     "'1234'",
  "unit_tilt_sector",            "high",  "m2",             3L,    "sector1",    "subsector2",     "'1234'",
  "unit_tilt_sector",            "high",  "m2",             3L,    "sector2",    "subsector1",     "'1234'",
  "unit_tilt_sector",            "high",  "m2",             3L,    "sector2",    "subsector2",     "'1234'",
  "unit_tilt_sector",            "high",  "kg",             3L,    "sector1",    "subsector1",     "'1234'",
  "unit_tilt_sector",            "high",  "kg",             3L,    "sector1",    "subsector2",     "'1234'",
  "unit_tilt_sector",            "high",  "kg",             3L,    "sector2",    "subsector1",     "'1234'",
  "unit_tilt_sector",            "high",  "kg",             3L,    "sector2",    "subsector2",     "'1234'"
  )
# styler: on

test_that("different benchmarks output different number of rows", {
  join_quietly <- function(x, y) {
    left_join(
      x, y,
      by = intersect(names(x), names(y)),
      relationship = "many-to-many"
    )
  }

  b <- tidyr::expand_grid(
    benchmark = c("all", "unit", "tilt_sector", "unit_tilt_sector"),
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

  benchmark <- "tilt_sector"
  expected <- 12
  # 12 = 3 emission_profile * 2 tilt_sector * 2 tilt_subsector
  out <- summarize_benchmark_impl(data)[[benchmark]]
  expect_equal(nrow(out), expected)

  benchmark <- "unit_tilt_sector"
  expected <- 24
  # 24 = 3 emission_profile * 2 tilt_sector * 2 tilt_subsector * 2 unit
  out <- summarize_benchmark_impl(data)[[benchmark]]
  expect_equal(nrow(out), expected)
})
