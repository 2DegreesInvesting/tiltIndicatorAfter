test_that("yields either `TRUE` or `FALSE` in `multi_match`", {
  out <- prepare_matches_mapper(small_matches_mapper, ecoinvent_activities)
  expect_true(unique(out$multi_match) %in% c(TRUE, FALSE))
})

test_that("`completion` column has either `low`, `medium`, or `high` values", {
  out <- prepare_matches_mapper(small_matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$completion), c("low", "high", "medium"))
})

test_that("doesn't have any empty string", {
  mm <- tibble(
    country = "a",
    main_activity = "a",
    clustered = "a",
    ep_id = "a",
    activity_uuid_product_uuid = NA_character_,
    multi_match = TRUE,
    completion = "a",
    category = "a"
  )

  ea <- tibble_names("a", names(ecoinvent_activities))
  out <- prepare_matches_mapper(mm, ea)

  expect_equal(out$activity_uuid_product_uuid, NA_character_)
})

test_that("stops if columns other than `activity_uuid_product_uuid` and `activity_name`
          have more than one unique value for specific group of columns", {
  mm <- tibble(
    country = c("x", "x"),
    main_activity = c("x", "x"),
    clustered = c("x", "x"),
    ep_id = c("a", "a"),
    activity_uuid_product_uuid = c("y", "z"),
    multi_match = c(TRUE, TRUE),
    completion = c("a", "a"),
    category = c("a", "a")
  )

  ea <- tibble(
    activity_uuid_product_uuid = c("y", "z"),
    activity_name = c("y", "z"),
    geography = c("a", "a"),
    reference_product_name = c("a", "a"),
    unit = c("a", "should be `a`")
  )

  expect_error(prepare_matches_mapper(mm, ea), "activity_uuid_product_uuid.*country")
})
