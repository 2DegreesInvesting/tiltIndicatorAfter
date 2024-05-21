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
