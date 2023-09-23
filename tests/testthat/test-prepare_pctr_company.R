test_that("total number of rows for a comapny is either 1 or 3", {
  out <- prepare_pctr_company(pctr_company, pctr_product, ep_companies, ecoinvent_activities, small_matches_mapper, isic_tilt_mapper) |>
    group_by(companies_id, benchmark) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})
