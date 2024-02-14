exec_profile <- function(.fn, indicator, indicator_after) {
  tilt_indicator_output <- exec(get(.fn), !!!indicator)
  if (.fn %in% c("emissions_profile", "emissions_profile_upstream")) {
    product_raw <- unnest_product(tilt_indicator_output) |>
      extend_with_columns_from_arguments_of_tilt_indicator(indicator, .fn)

    set.seed(111)
    co2_range <- create_co2_range(product_raw)
    product <- add_co2_upper_lower(product_raw, co2_range)

    company <- unnest_company(tilt_indicator_output) |>
      add_co2_upper_lower(co2_range)
  } else {
    product <- unnest_product(tilt_indicator_output) |>
      extend_with_columns_from_arguments_of_tilt_indicator(indicator, .fn)
    company <- unnest_company(tilt_indicator_output)
  }

  out_product <-
    exec(polish_product(.fn), product, !!!indicator_after)
  out_company <-
    exec(polish_company(.fn), company, product, !!!indicator_after)

  nest_levels(out_product, out_company)
}

extend_with_columns_from_arguments_of_tilt_indicator <-
  function(product,
           indicator,
           .fn) {
    if (grepl("sector_profile$", .fn)) {
      companies <- indicator[[1]]
      out <- product |> extend_with(companies)
    }
    if (grepl("emissions", .fn)) {
      co2 <- indicator[[2]]
      out <- product |> extend_with(co2)
    }
    if (grepl("sector_profile_upstream$", .fn)) {
      inputs <- indicator[[3]]
      out <- product |> extend_with(inputs)
    }

    out
  }

extend_with <-
  function(data, with, cols_pattern = extra_cols_pattern()) {
    .with <- with |> select(matches(cols_pattern))
    .data <- data |> select(-any_of(names(.with)), matches("rowid"))
    left_join(.data, .with, by = extra_rowid())
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
  rowid_to_column(data, extra_rowid())
}

extra_rowid <- function() {
  "extra_rowid"
}

create_co2_range <- function(data) {
  data |>
    summarize_range(grep("co2_footprint", names(data)),
                    .by = c("grouped_by", "risk_category")) |>
    jitter_range() |>
    select(-c("min", "max")) |>
    rename(co2e_lower = "min_jitter", co2e_upper = "max_jitter")
}

add_co2_upper_lower <- function(data, co2_range) {
  left_join(data, co2_range, by = join_by("grouped_by", "risk_category"))
}
