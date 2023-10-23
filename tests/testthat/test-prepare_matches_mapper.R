test_that("yields either `TRUE` or `FALSE` in `multi_match`", {
  out <- prepare_matches_mapper(small_matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$multi_match), c(TRUE, FALSE))
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
    country = "x",
    main_activity = "x",
    clustered = "x",
    ep_id = "a",
    activity_uuid_product_uuid = c("y", "z"),
    multi_match = TRUE,
    completion = "a",
    category = "a"
  )

  ea <- tibble(
    activity_uuid_product_uuid = c("y", "z"),
    activity_name = c("y", "z"),
    geography = "a",
    reference_product_name = "a",
    unit = c("a", "should be `a`")
  )

  expect_error(prepare_matches_mapper(mm, ea), "activity_uuid_product_uuid.*country")
})

test_that("outputs non-null output for group of columns `country`, `main_activity`,
          and `clustered` if there are NAs are also present in other columns", {
  mm <- tibble(
    country = "x",
    main_activity = "x",
    clustered = "x",
    ep_id = "a",
    activity_uuid_product_uuid = "a",
    multi_match = TRUE,
    completion = "a",
    category = "a"
  )

  ea <- tibble(
    activity_uuid_product_uuid = "a",
    activity_name = "a",
    geography = "a",
    reference_product_name = "a",
    unit = c("a", NA)
  )

  out <- prepare_matches_mapper(mm, ea)
  expect_equal(nrow(out), 1)
})

test_that("stops if `multi_match` is not logical", {
  mm <- tibble_names("a", names(matches_mapper))
  all_characters_none_logical <- "a"
  ea <- tibble_names(all_characters_none_logical, names(ecoinvent_activities))

  expect_error(prepare_matches_mapper(mm, ea), "logical.*multi_match.*not TRUE")
})
