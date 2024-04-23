test_that("if matches a column, excludes the column and duplicated rows", {
  data <- tibble(x = c(1, 1), y = x)

  out <- exclude(data, "y")

  expect_false(hasName(out, "y"))
  expect_true(nrow(out) < nrow(data))
})

test_that("if doesn't match any column, yields the inpt data", {
  data <- tibble(x = c(1, 1), y = x)

  out <- exclude(data, "unmatched")

  expect_equal(out, data)
})

test_that("with a tilt_profile yields a tilt_profile", {
  product <- company <- tibble(companies_id = c(1, 1), y = companies_id)
  result <- tilt_profile(nest_levels(product, company))

  out <- exclude(result, "y")

  expect_s3_class(out, "tilt_profile")
})

test_that("with a tilt_profile excludes at both levels", {
  product <- company <- tibble(companies_id = c(1, 1), y = companies_id)
  result <- tilt_profile(nest_levels(product, company))

  out <- exclude(result, "y")

  expect_false(hasName(unnest_product(out), "y"))
  expect_false(hasName(unnest_company(out), "y"))

  expect_true(nrow(unnest_product(out)) < nrow(product))
  expect_true(nrow(unnest_company(out)) < nrow(company))
})
