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
    ~companies_id, ~ep_product, ~benchmark_tr_score, ~transition_risk_category, ~transition_risk_score,
            "any",       "one",               "all",                     "low",                    1.0,
            "any",       "two",               "all",                  "medium",                    2.0,
            "any",     "three",               "all",                    "high",                    3.0,
  )
  # styler: on
)

example_best_case_worst_case_profile_ranking_product_level <- example_data_factory(
  # styler: off
  tribble(
    ~companies_id, ~ep_product, ~benchmark, ~emission_profile, ~profile_ranking,
            "any",       "one",      "all",             "low",              1.0,
            "any",       "two",      "all",          "medium",              2.0,
            "any",     "three",      "all",            "high",              3.0,
  )
  # styler: on
)

example_risk_categories_at_product_level <- example_data_factory(
  # styler: off
  tribble(
    ~companies_id, ~ep_product, ~benchmark_tr_score, ~transition_risk_category,
            "any",         "a",               "all",                     "low",
            "any",         "a",               "all",                  "medium",
            "any",         "a",               "all",                    "high",
            "any",         "b",              "unit",                     "low",
            "any",         "b",              "unit",                  "medium",
            "any",         "b",              "unit",                    "high",
  )
  # styler: on
)
