example_best_case_worst_case_emission_profile <- example_data_factory(
  # styler: off
  tribble(
    ~companies_id, ~ep_product, ~benchmark, ~emission_profile,
            "any",       "one",      "all",             "low",
            "any",       "two",      "all",          "medium",
            "any",     "three",      "all",            "high"
  )
  # styler: on
)

example_best_case_worst_case_transition_risk_profile <- example_data_factory(
  # styler: off
  tribble(
    ~companies_id, ~ep_product, ~benchmark_tr_score, ~transition_risk_category,
            "any",       "one",               "all",                     "low",
            "any",       "two",               "all",                  "medium",
            "any",     "three",               "all",                    "high"
  )
  # styler: on
)

example_best_case_worst_case_transition_risk_profile_product_level <- example_data_factory(
  # styler: off
  tribble(
    ~companies_id, ~ep_product, ~benchmark_tr_score, ~transition_risk_category, ~amount_of_distinct_products,
            "any",       "one",               "all",                     "low",                          3.0,
            "any",       "two",               "all",                  "medium",                          3.0,
            "any",     "three",               "all",                    "high",                          3.0,
  )
  # styler: on
)
