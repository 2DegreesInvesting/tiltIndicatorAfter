join_everything <- function(x, y) {
  shared <- intersect(names(x), names(y))
  right_join(y, x, by = shared, relationship = "many-to-many")
}
