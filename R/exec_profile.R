exec_profile <- function(.fn, indicator, indicator_after) {
  tilt_indicator_output <- exec(get(.fn), !!!indicator)

  product <- unnest_product(tilt_indicator_output)
  if (grepl("sector_profile$", .fn)) {
    companies <- indicator[[1]]
    product <- extend_with(product, companies)
  }
  if (grepl("emissions", .fn)) {
    co2 <- indicator[[2]]
    product <- extend_product(product, co2)
  }
  if (grepl("sector_profile_upstream$", .fn)) {
    inputs <- indicator[[3]]
    product <- extend_with(product, inputs)
  }
  company <- unnest_company(tilt_indicator_output)

  out_product <- exec(polish_product(.fn), product, !!!indicator_after)
  out_company <- exec(polish_company(.fn), company, product, !!!indicator_after)

  nest_levels(out_product, out_company)
}

extend_product <- function(product, .co2, cols_pattern = extra_cols_pattern()) {
  left_join(product, select(.co2, matches(cols_pattern)), by = "co2_rowid")
}

extend_with <- function(data, with, cols_pattern = extra_cols_pattern()) {
  .data <- data |> select(-matches(cols_pattern), matches("rowid"))
  .with <- with |> select(matches(cols_pattern))
  left_join(.data, .with, by = "extra_rowid")
}

extra_cols_pattern <- function() {
  c("rowid", "isic", "sector")
}

polish_product <- function(.fn) {
  get(glue("polish_{.fn}_product"))
}

polish_company <- function(.fn) {
  get(glue("polish_{.fn}_company"))
}

add_rowid <- function(data) {
  label <- deparse(substitute(data))
  rowid_to_column(data, paste0(label, "_rowid"))
}
