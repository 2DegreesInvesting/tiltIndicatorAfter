add_transition_risk_category_at_company_level <- function(data) {
  data |>
    rename(grouped_by = "benchmark_tr_score", risk_category = "transition_risk_category") |>
    epa_at_company_level() |>
    insert_row_with_na_in_risk_category() |>
    rename(benchmark_tr_score_avg = "grouped_by", transition_risk_category = "risk_category", transition_risk_category_share = "value")
}

join_risk_categories_at_company_level <- function(data, risk_categories) {
  data |>
    mutate(original_emission_profile = .data$emission_profile) |>
    left_join(risk_categories, by = c("companies_id", "benchmark_tr_score_avg", "emission_profile" = "transition_risk_category")) |>
    rename(transition_risk_category = "original_emission_profile")
}
