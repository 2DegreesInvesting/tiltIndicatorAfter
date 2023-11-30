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
