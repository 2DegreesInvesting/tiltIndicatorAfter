test_that("total number of rows for a comapny is either 1 or 3", {
  out <- prepare_istr_company(istr_company, istr_product, ep_companies, ecoinvent_activities, small_matches_mapper, ecoinvent_inputs) |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})
