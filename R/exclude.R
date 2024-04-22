exclude <- function(data, excluding) {
  distinct(select(data, -matches(excluding)))
}
