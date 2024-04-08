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

test_that("can avoid list-columns, the warning, and duplicates", {
  # styler: off
  data <- tribble(
    ~to_exclude,  ~id, ~name,  ~value,
              1, "id",   "a",       1,
              2, "id",   "a",       1,
  ) |>
    mutate(another_col_that_yields_duplicates = to_exclude)
    # styler: on


  expect_no_warning({
    out <- exclude_cols_then_pivot_wider(
      data,
      exclude_cols = "to_exclude",
      id_cols = "id",
      avoid_list_cols = TRUE
    )
  })

  expect_type(out$a, "double")
})
