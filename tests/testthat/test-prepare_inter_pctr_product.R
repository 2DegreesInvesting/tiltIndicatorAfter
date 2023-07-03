test_that("`avg_matching_certainty` should have only one value", {
  out <- prepare_inter_pctr_product(pctr_product, companies, ecoinvent_activities, matches_mapper) |>
    group_by(companies_id) |>
    summarise(count = dplyr::n_distinct(avg_matching_certainty))
  expect_equal(unique(out$count), 1)
})
