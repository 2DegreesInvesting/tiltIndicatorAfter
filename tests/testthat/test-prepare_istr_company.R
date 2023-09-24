test_that("total number of rows for a comapny is either 1 or 3", {
  out <- prepare_istr_company(istr_company, istr_product, ep_companies, ecoinvent_activities, small_matches_mapper, ecoinvent_inputs) |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("throws no error", {
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())

  result <- sector_profile_upstream(companies, scenarios, inputs)
  company <- unnest_company(result)
  product <- unnest_product(result)

  expect_no_error(
    prepare_istr_company(
      company,
      product,
      ep_companies |> head(1),
      ecoinvent_activities |> head(1),
      matches_mapper |> head(1),
      ecoinvent_inputs |> head(1)
    )
  )
})
