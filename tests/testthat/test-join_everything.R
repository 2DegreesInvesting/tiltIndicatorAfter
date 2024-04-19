test_that("yields the `data`", {
  data <- tibble(x = 1:4, y = letters[c(1, 1, 2, 2)])

  out <- data |>
    summarise(z = mean(x), .by = y) |>
    join_everything(data)

  expect_equal(select(out, -z), data)
})

test_that("can do a round-trip", {
  x <- tibble(a = c("a", "a"))
  y <- tibble(a = c("a"), b = "b")

  expect_equal(join_everything(y, x), join_everything(x, y))
})
