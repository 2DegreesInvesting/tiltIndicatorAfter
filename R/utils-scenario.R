recode_scenario <- function(x) {
  out <- gsub("^ipr|^weo", "", x, ignore.case = TRUE)
  out <- gsub("_", " ", out)
  tolower(trimws(out))
}
