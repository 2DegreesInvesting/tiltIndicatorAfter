test_that("total number of rows for a comapny is either 1, 2 or 4", {
  out <- prepare_pstr_product(
    pstr_product,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper
  ) |>
    group_by(companies_id, ep_product, activity_uuid_product_uuid) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 2, 4)))
})
