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

test_that("is sensitive to `excluding`", {
  data <- tibble(x = rep(1, 4), y = letters[rep(c(1, 2), 2)], z = 1:4)

  out1 <- data |>
    summarise(mean = mean(x), .by = "y") |>
    join_to(data)
  expect_true(hasName(out1, "z"))

  out2 <- data |>
    summarise(mean = mean(x), .by = "y") |>
    join_to(data, excluding = "z")
  expect_false(hasName(out2, "z"))

  expect_true(nrow(out1) > nrow(out2))
})
