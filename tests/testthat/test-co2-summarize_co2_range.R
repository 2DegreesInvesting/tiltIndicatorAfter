test_that("different benchmarks output different number of rows", {
  x <- tidyr::expand_grid(
    benchmark = c("all", "unit", "tilt_sector", "unit_tilt_sector"),
    emission_profile = c("low", "medium", "high"),
    unit = c("m2", "kg"),
    tilt_sector = c("sector1", "sector2"),
    tilt_subsector = c("subsector1", "subsector2"),
  )
  y <- tibble(
    emission_profile = c("low", "medium", "high"),
    isic_4digit = "'1234'",
    co2_footprint = 1:3,
  )
  data <- left_join(x, y, by = "emission_profile", relationship = "many-to-many")

  benchmark <- "all"
  expected <- 3
  # 3 = 3 emission_profile
  out <- summarize_co2_range(data)
  expect_equal(nrow(filter(out, benchmark == .env$benchmark)), expected)

  benchmark <- "unit"
  expected <- 6
  # 6 = 3 emission_profile * 2 unit
  out <- summarize_co2_range(data)
  expect_equal(nrow(filter(out, benchmark == .env$benchmark)), expected)

  benchmark <- "tilt_sector"
  expected <- 12
  # 12 = 3 emission_profile * 2 tilt_sector * 2 tilt_subsector
  out <- summarize_co2_range(data)
  expect_equal(nrow(filter(out, benchmark == .env$benchmark)), expected)

  benchmark <- "unit_tilt_sector"
  expected <- 24
  # 24 = 3 emission_profile * 2 tilt_sector * 2 tilt_subsector * 2 unit
  out <- summarize_co2_range(data)
  expect_equal(nrow(filter(out, benchmark == .env$benchmark)), expected)
})

test_that("with a simple case yields the same as `summarize_range()` (214#issuecomment-2061180499)", {
  # styler: off
  data <- tribble(
    ~benchmark, ~emission_profile, ~co2_footprint, ~unit, ~tilt_sector, ~tilt_subsector, ~isic_4digit,
         "all",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
         "all",          "medium",             2L,  "m2",    "sector1",    "subsector2",     "'1234'"
  )
  # styler: on

  expect_equal(
    summarize_range(
      data,
      col_footprint(),
      .by = c(col_benchmark(), col_risk_category())
    ),
    summarize_co2_range(data)
  )
})

test_that("is vectorized over `benchmark`", {
  # styler: off
  data <- tribble(
    ~benchmark, ~emission_profile, ~co2_footprint, ~unit, ~tilt_sector, ~tilt_subsector, ~isic_4digit,
         "all",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
        "unit",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
  )
  # styler: on

  out <- summarize_co2_range(data)
  expect_equal(unique(out$benchmark), c("all", "unit"))
})

test_that("without crucial columns errors gracefully", {
  # styler: off
  data <- tribble(
          ~benchmark, ~emission_profile, ~co2_footprint, ~unit, ~tilt_sector, ~tilt_subsector, ~isic_4digit,
               "all",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
              "unit",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
       "tilt_sector",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
    "tilt_subsector",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
       "isic_4digit",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
  )
  # styler: on

  crucial <- col_footprint()
  bad <- select(data, -all_of(crucial))
  expect_error(summarize_co2_range(bad), crucial)

  crucial <- col_benchmark()
  bad <- select(data, -all_of(crucial))
  expect_error(summarize_co2_range(bad), class = "check_matches_name")

  crucial <- "emission_profile"
  bad <- select(data, -all_of(crucial))
  expect_error(summarize_co2_range(bad), class = "check_matches_name")

  crucial <- "unit"
  bad <- select(data, -all_of(crucial))
  expect_error(summarize_co2_range(bad), crucial)

  crucial <- "tilt_sector"
  bad <- select(data, -all_of(crucial))
  expect_error(summarize_co2_range(bad), crucial)

  crucial <- "tilt_subsector"
  bad <- select(data, -all_of(crucial))
  expect_error(summarize_co2_range(bad), crucial)

  crucial <- "tilt_subsector"
  bad <- select(data, -all_of(crucial))
  # summarize_co2_range(bad)
  expect_error(summarize_co2_range(bad), crucial)

  crucial <- "isic_4digit"
  bad <- select(data, -all_of(crucial))
  expect_error(summarize_co2_range(bad), crucial)
})
