test_that("total number of rows for a comapny is either 1, 4, 12", {
  out <- prepare_istr_product(istr_product, ep_companies, ecoinvent_activities, matches_mapper, ecoinvent_inputs) |>
    group_by(companies_id, ep_product, input_name) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 4, 12)))
})
