test_that("excludes clolumns", {
  data <- tibble(x = 1, z = 1)
  expect_equal(names_diff(data, exclude(data, "z")), "z")
})

test_that("excludes rows", {
  data <- tibble(x = c(1, 1), y = x)
  expect_true(nrow(data) > nrow(exclude(data, "z")))
})
