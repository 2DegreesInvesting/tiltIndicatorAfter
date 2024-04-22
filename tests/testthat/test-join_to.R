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

test_that("with a profile_result yields a profile_result", {
  skip("TODO")
  # TODO: Rename profile_result to profile
  product <- tibble(companies_id = 1:3, x = 1:3)
  company <- tibble(companies_id = 1:3, y = 1)
  profile <- nest_levels(product, company)

  summary <- summarise(product, mean = mean(x))

  joint_profile <- summary |> join_to(profile)

  expect_true(has_profile_names(profile_result))
  expect_true(has_profile_names(joint_profile))
})

test_that("works with 'profile_result'", {
  skip("TODO")
  product <- tibble(companies_id = 1:3, x = 1:3)
  company <- tibble(companies_id = 1:3, y = 1)
  profile <- nest_levels(product, company)

  summary <- summarise(product, mean = mean(x))

  joint_product <- summary |> join_to(product)
  joint_company <- summary |> join_to(company)
  joint_profile <- summary |> join_to(profile)

  expect_equal(
    joint_profile |> unnest_product(),
    joint_product
  )

  expect_equal(
    joint_profile |> unnest_company(),
    joint_company
  )
})
