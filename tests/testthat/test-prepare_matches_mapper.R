test_that("`multi_match` column has either `TRUE` or `FALSE` values", {
  out <- prepare_matches_mapper(small_matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$multi_match), c("TRUE", "FALSE"))
})

test_that("`completion` column has either `low`, `medium`, or `high` values", {
  out <- prepare_matches_mapper(small_matches_mapper, ecoinvent_activities)
  expect_equal(unique(out$completion), c("low", "high", "medium"))
})

test_that("`prepare_matches_mapper` doesn't have any empty string", {
  tibble_names <- function(x, nms) {
    m <- matrix(x, ncol = length(nms), dimnames = list(NULL, nms))
    tibble::as_tibble(m)
  }

  mm <- tibble_names("a", names(matches_mapper))
  mm$activity_uuid_product_uuid <- NA_character_
  ea <- tibble_names("a", names(ecoinvent_activities))

  out <- prepare_matches_mapper(mm, ea)
  expect_equal(out$activity_uuid_product_uuid, NA_character_)
})

test_that("`multi_match` column outputs `FALSE` for null input value", {
  tibble_names <- function(x, nms) {
    m <- matrix(x, ncol = length(nms), dimnames = list(NULL, nms))
    tibble::as_tibble(m)
  }

  mm <- tibble_names("a", names(matches_mapper))
  mm$multi_match <- NA_character_
  ea <- tibble_names("a", names(ecoinvent_activities))

  out <- prepare_matches_mapper(mm, ea)
  expect_equal(unique(out$multi_match), c("FALSE"))
})
