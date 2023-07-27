test_that("total number of rows for a comapny is either 1 or 3", {
  out <- prepare_ictr_company(ictr_company, ictr_product, ep_companies, ecoinvent_activities, matches_mapper, ecoinvent_inputs) |>
    group_by(companies_id, benchmark) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})