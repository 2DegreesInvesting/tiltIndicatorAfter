test_that("total number of rows for a comapny is either 1 or 3", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies = ep_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = small_matches_mapper,
    isic_tilt = isic_tilt_mapper
  ) |>
    unnest_company() |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())

  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("'empty' tiltIndicator results yield at most 1 NA in *risk_category", {
  skip("FIXME: Rewrite using the new API")

  product <- unnest_product(toy_sector_profile_output())
  product_empty <- product[1, ]
  product_empty[1, "companies_id"] <- "a"
  product_empty[1, "risk_category"] <- NA_character_

  company_empty <- tibble(
    companies_id = "a",
    grouped_by = NA_character_,
    risk_category = NA_character_,
    value = NA_real_
  )

  result <- prepare_pstr_company(
    company_empty,
    product_empty,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    isic_tilt_mapper
  )
  out <- result |>
    filter(is.na(get_column(result, "risk_category"))) |>
    group_by(companies_id) |>
    summarise(count = n())

  expect_lte(unique(out$count), 1)
})
