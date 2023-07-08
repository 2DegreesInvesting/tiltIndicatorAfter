test_that("risk_category colummn should not have more than one NA for no result companies", {
  out <- prepare_inter_pstr_product(pstr_product, ep_companies, ecoinvent_activities, matches_mapper) |>
    filter(is.na(risk_category)) |>
    group_by(companies_id) |>
    summarise(count=n())

  expect_equal(unique(out$count), 1L)
})
