test_that("`multi_match` column has either `TRUE` or `FALSE` values", {
  out <- prepare_matches_mapper(small_matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$multi_match), c("TRUE", "FALSE"))
})

test_that("`completion` column has either `low`, `medium`, or `high` values", {
  out <- prepare_matches_mapper(small_matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$completion), c("low", "high", "medium"))
})

test_that("prepare_matches_mapper doesn't have any empty string", {
  matches_mapper <- tibble(
    ep_id = c("b", "a", "all"),
    country = c("b", "a", "all"),
    main_activity = c("b", "a", "all"),
    clustered = c("b", "a", "all"),
    activity_uuid_product_uuid = c("b", "any", NA_character_),
    multi_match = c("b", "a", "all"),
    completion = c("b", "a", "all"),
    category = c("b", "a", "all")
  )

  ecoinvent_activities <- tibble(
    activity_uuid_product_uuid = c("any", NA_character_),
    activity_name = c(NA_character_, "c"),
    geography = c("d", NA_character_),
    reference_product_name = c("d", NA_character_),
    unit = c("d", "c")
  )

  out <- prepare_matches_mapper(matches_mapper, ecoinvent_activities)
  final <- unlist(out)
  expect_false(any(final[!is.na(final)] == ""))
})
