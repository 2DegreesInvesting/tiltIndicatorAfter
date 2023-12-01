test_that("the new API is equivalent to the old API except for extra columns", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)

  # New API
  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages
  )

  # Old API
  output <- sector_profile(companies, scenarios)
  product <- unnest_product(output)
  company <- unnest_company(output)

  out_product <- prepare_pstr_product(
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages
  )

  out_company <- prepare_pstr_company(
    company,
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages
  )

  standardize_profile <- function(data) {
    data |>
      arrange(companies_id) |>
    select(-matches(extra_cols_pattern()))
  }

  expect_equal(
    out |> unnest_product() |> standardize_profile(),
    out_product |> standardize_profile()
  )
  expect_equal(
    out |> unnest_company() |> standardize_profile(),
    out_company |> standardize_profile()
  )
})

test_that("the output at product level has columns matching isic and sector", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages
  )

  product <- unnest_product(out)
  expect_true(any(matches_name(product, "isic")))
  expect_true(any(matches_name(product, "sector")))
})
