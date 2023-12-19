select_europages_companies <- function(data) {
  data |>
    select(
      "company_name",
      "country",
      "company_city",
      "postcode",
      "address",
      "main_activity",
      "companies_id"
    )
}

select_ecoinvent_inputs <- function(data) {
  data |>
    select(
      "input_activity_uuid_product_uuid",
      "exchange_name",
      "exchange_unit_name"
    ) |>
    distinct()
}
