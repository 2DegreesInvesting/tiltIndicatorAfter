test_that("sanitize_co2() does no padding", {
  local_options(readr.show_col_types = FALSE)

  out <- sanitize_isic(read_csv("isic_4digit\n1\n12\n123"))
  expect_equal(out$isic_4digit, c("1", "12", "123"))
})

test_that("sanitize_co2() converts `*isic*` as character", {
  local_options(readr.show_col_types = FALSE)

  out <- sanitize_isic(read_csv("isic_4digit\n1"))
  expect_type(out$isic_4digit, "character")
})

test_that("sanitize_co2() works with both products and upstream products", {
  local_options(readr.show_col_types = FALSE)

  out <- sanitize_isic(tibble(isic_4digit = 1))
  expect_equal(out$isic_4digit, c("1"))

  out <- sanitize_isic(tibble(input_isic_4digit = 1))
  expect_equal(out$input_isic_4digit, c("1"))
})
