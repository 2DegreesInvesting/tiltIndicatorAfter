test_that("excludes columns matching a pattern and leaves no duplicates", {
  # styler: off
  data <- tribble(
    ~to_exclude,  ~id, ~name,  ~value,
              1, "id",   "a",       1,
              2, "id",   "a",       1,
              1, "id",   "b",       2,
              2, "id",   "b",       2,
  )
  # styler: on

  out <- exclude_cols_then_pivot_wider(data, exclude_cols = "exclude")
  expect_equal(nrow(out), 1L)
  expect_false(hasName(out, "to_exclude"))
})
