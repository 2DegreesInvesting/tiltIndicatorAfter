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
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())

  result <- profile_sector(
    companies,
    scenarios,
    europages_companies = ep_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = small_matches_mapper,
    isic = isic_name
  ) |>
    unnest_product()

  expected_col_name <- "sector_profile"
  expect_true(expected_col_name %in% colnames(result))
})

test_that("rename_118() function is not applied if issue #118 is not addressed", {
  withr::local_options(tiltIndicatorAfter.dissable_issue_118 = TRUE)
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())

  result <- profile_sector(
    companies,
    scenarios,
    europages_companies = ep_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = small_matches_mapper,
    isic = isic_name
  ) |>
    unnest_product()

  expected_col_name <- "PSTR_risk_category"
  expect_true(expected_col_name %in% colnames(result))
})
