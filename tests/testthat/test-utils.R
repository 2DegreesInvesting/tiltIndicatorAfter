test_that("sanitize_co2() does no padding", {
  local_options(readr.show_col_types = FALSE)

  out <- sanitize_isic(read_csv("isic_4digit\n1\n12\n123"))
  expect_equal(out$isic_4digit, c("1", "12", "123"))
})

test_that("sanitize_co2() converts `*isic*` as character", {
  local_options(readr.show_col_types = FALSE)

  out <- sanitize_isic(read_csv("isic_4digit\n1"))
  expect_type(out$isic_4digit, "character")
})

test_that("sanitize_co2() works with both products and upstream products", {
  local_options(readr.show_col_types = FALSE)

  out <- sanitize_isic(tibble(isic_4digit = 1))
  expect_equal(out$isic_4digit, c("1"))

  out <- sanitize_isic(tibble(input_isic_4digit = 1))
  expect_equal(out$input_isic_4digit, c("1"))
})

test_that("rename_118() function is applied if issue #118 is addressed", {
  withr::local_options(tiltIndicatorAfter.dissable_issue_118 = FALSE)
  local_options(readr.show_col_types = FALSE)
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())

  europages_companies <- read_csv(toy_europages_companies()) |> head(1)
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities()) |> head(1)
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages()) |> head(1)
  isic_name <- read_csv(toy_isic_name()) |> head(1)

  result <- profile_sector(
    companies,
    scenarios,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_company()

  actual_col_name <- "sector_profile$"
  expected_col_name <- "sector_profile"
  expect_equal(grep(actual_col_name, names(result), value = TRUE), expected_col_name)
})

test_that("rename_118() function is not applied if issue #118 is not addressed", {
  withr::local_options(tiltIndicatorAfter.dissable_issue_118 = TRUE)
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())

  europages_companies <- read_csv(toy_europages_companies()) |> head(1)
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities()) |> head(1)
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages()) |> head(1)
  isic_name <- read_csv(toy_isic_name()) |> head(1)

  result <- profile_sector(
    companies,
    scenarios,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_company()

  actual_col_name <- "PSTR_risk_category"
  expected_col_name <- "PSTR_risk_category"
  expect_equal(grep(actual_col_name, names(result), value = TRUE), expected_col_name)
})

test_that("`stop_if_percent_noise_more_than_100` throws an error if added noise is more than 100%", {
  data <- tibble(
    min = 1,
    max = 2,
    max_jitter = 10000,
    min_jitter = 10000
  )

  expect_error(stop_if_percent_noise_more_than_100(data))
})

