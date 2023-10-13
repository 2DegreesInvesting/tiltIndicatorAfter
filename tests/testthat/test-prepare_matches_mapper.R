test_that("`multi_match` column has either `TRUE` or `FALSE` values", {
  out <- prepare_matches_mapper(small_matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$multi_match), c(TRUE, FALSE))
})

test_that("`completion` column has either `low`, `medium`, or `high` values", {
  out <- prepare_matches_mapper(small_matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$completion), c("low", "high", "medium"))
})

test_that("`prepare_matches_mapper` doesn't have any empty string", {
  mm <- tibble_names("a", names(matches_mapper))
  mm$activity_uuid_product_uuid <- NA_character_
  ea <- tibble_names("a", names(ecoinvent_activities))

  out <- prepare_matches_mapper(mm, ea)
  expect_equal(out$activity_uuid_product_uuid, NA_character_)
})

test_that("`multi_match` column outputs `FALSE` for null and empty string value", {
  mm <- tibble(
    country = c("x", "y"),
    main_activity = c("a", "a"),
    clustered = c("a", "a"),
    ep_id = c("a", "a"),
    activity_uuid_product_uuid = c("a", "a"),
    multi_match = c(NA_character_, ""),
    completion = c("a", "a"),
    category = c("a", "a")
  )

  ea <- tibble_names("a", names(ecoinvent_activities))
  out <- prepare_matches_mapper(mm, ea)

  expect_false(unique(out$multi_match))
})
