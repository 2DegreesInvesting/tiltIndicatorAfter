test_that("`multi_match` column has either `TRUE` or `FALSE` values", {
  out <- prepare_matches_mapper(matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$multi_match), c("TRUE", "FALSE"))
})

test_that("`completion` column has either `low`, `medium`, or `high` values", {
  out <- prepare_matches_mapper(matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$completion), c("low", "high", "medium"))
})
