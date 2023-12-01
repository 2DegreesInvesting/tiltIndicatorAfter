test_that("the new API is equivalent to the old API except for extra columns", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  ecoinvent_inputs <- ecoinvent_inputs |> head(3)

  # New API
  out <- profile_sector_upstream(
    companies,
    scenarios,
    inputs,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs
  )

  # Old API
  output <- sector_profile_upstream(companies, scenarios, inputs)
  product <- unnest_product(output)
  company <- unnest_company(output)

  out_product <- prepare_istr_product(
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs
  )

  out_company <- prepare_istr_company(
    company,
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs
  )

  expect_equal(
    out |> unnest_product() |> arrange_and_exclude_extra_columns(),
    out_product |> arrange_and_exclude_extra_columns()
  )
  expect_equal(
    out |> unnest_company() |> arrange_and_exclude_extra_columns(),
    out_company |> arrange_and_exclude_extra_columns()
  )
})
