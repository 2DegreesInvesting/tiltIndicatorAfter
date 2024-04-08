test_that("comes from tiltIndicatorAfter not tiltToyData", {
  europages_companies <- read_csv(toy_europages_companies())
  expect_true(grepl("tiltIndicatorAfter", toy_europages_companies()))
  expect_false(grepl("tiltToyData", toy_europages_companies()))
  expect_true(grepl("tiltToyData", tiltToyData::toy_europages_companies()))
})

test_that("has `*headcount` columns", {
  europages_companies <- read_csv(toy_europages_companies())
  hasName(europages_companies, "min_headcount")
  hasName(europages_companies, "max_headcount")
})
