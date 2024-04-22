test_that("joins as expected", {
  # styler: off
  data <- tibble::tribble(
    ~benchmark, ~emission_profile, ~co2_footprint, ~unit, ~tilt_sector, ~tilt_subsector, ~isic_4digit,
         "all",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
         "all",             "low",             2L,  "m2",    "sector1",    "subsector1",     "'1234'",
         "all",            "high",             3L,  "m2",    "sector1",    "subsector1",     "'1234'",
         "all",            "high",             4L,  "m2",    "sector1",    "subsector1",     "'1234'",
        "unit",             "low",             1L,  "m2",    "sector1",    "subsector1",     "'1234'",
        "unit",             "low",             2L,  "m2",    "sector1",    "subsector1",     "'1234'",
        "unit",            "high",             3L,  "m2",    "sector1",    "subsector1",     "'1234'",
        "unit",            "high",             4L,  "m2",    "sector1",    "subsector1",     "'1234'",
  )
  # styler: off

  summary <- summarize_co2_range(data)
  expected <- suppressMessages(left_join(data, summary))
  expect_equal(join_to(summary, data), expected)
})
