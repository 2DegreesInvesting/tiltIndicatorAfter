<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# tiltIndicatorAfter 0.0.0.9005 (2023-09-24)

* Retire internal functions from the public API (#53):
  * `prepare_inter_pctr_product()`.
  * `prepare_inter_pstr_product()`.
  * `prepare_matches_mapper()`.

# tiltIndicatorAfter 0.0.0.9004 (2023-09-24)

* `prepare_pstr_company()` now accepts the output of `tiltIndicator::sector_profile()` 'as is' (#50).

# tiltIndicatorAfter 0.0.0.9003 (2023-09-24)

* `prepare_pctr_product()` No longer errors with "Column unit doesn't exist" (#26).

# tiltIndicatorAfter 0.0.0.9002 (2023-09-24)

* Emmisions functions no longer error if the column `*isic_4digit` is numeric (#42).

# tiltIndicatorAfter 0.0.0.9001 (2023-09-22)

* New article showing how to enhance results (TiltDevProjectMGMT#126).
