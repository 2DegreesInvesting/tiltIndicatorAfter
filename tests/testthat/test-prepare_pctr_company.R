test_that("total number of rows for a comapny is either 1 or 18", {
  out <- prepare_pctr_company(pctr_company, pctr_product, companies, ecoinvent_activities, matches_mapper) |>
    group_by(companies_id) |>
    summarise(count=n())
  expect_equal(unique(out$count), c(18, 1))
})
