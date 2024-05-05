<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# tiltIndicatorAfter 0.0.0.9037 (2024-05-03)

* `profile_emissions*()` at company level no longer outputs the columns
`co2e_lower` and `co2e_upper` (#231). Also, the company level output no longer
includes the licensed `min` and `max` columns. If necessary, the `min` and `max`
columns can still be demanded a product level.

# tiltIndicatorAfter 0.0.0.9036 (2024-04-29)

* New developer-oriented `toy_profile_emissions_impl_output()`, makes tests easier
to write and faster to run  (#228).

# tiltIndicatorAfter 0.0.0.9035 (2024-04-27)

* Link to `profile_impl` from top-level functions (#227). This helps to discover
the developer-oriented composable friends.

# tiltIndicatorAfter 0.0.0.9034 (2024-04-27)

* The internal topic `?composable_friends` is now removed (#225). Instead you may
see `?profile_impl` and follow linked topics.

# tiltIndicatorAfter 0.0.0.9033 (2024-04-23)

* The documented 'Value' of each `profile_*()` no longer refers to columns that
don't exist (#221).

# tiltIndicatorAfter 0.0.0.9032 (2024-04-23)

* `profile_*()` now yield objects of [S3
class](https://adv-r.hadley.nz/s3.html#s3) 'tilt\_profile' (#219). This allows
creating generics with specialized methods.

# tiltIndicatorAfter 0.0.0.9031 (2024-04-23)

* New internal `profile_*impl()` (#222). This initiates an alternative
developer-oriented API documented at `?composable_friends`.

# tiltIndicatorAfter 0.0.0.9030 (2024-04-10)

* `profile_emissions()` and `profile_emissions_upstream()` now inform a meaningful
percent noise (#212). This fixes a bug where the message reported a noise of
"NA%".

# tiltIndicatorAfter 0.0.0.9029 (2024-04-09)

* New internal `score_transition_risk_and_polish()` wraps and generalizes the
latest script used to format outputs before delivery (#205).

# tiltIndicatorAfter 0.0.0.9028 (2024-04-09)

* `exclude_cols_then_pivot_wider()` gains `avoid_list_cols` (#206). This is a
coarse, catch-all alternative to the finer grained control you get via the
`id_cols` of `tidyr::pivot_wider()`. While it's generally best to specify the
id_cols you care about, it's hard to anticipate what columns the real data might
have, and some of them may introduce list-columns, duplicates, and trigger a
warning. This new argument avoids all of that.

# tiltIndicatorAfter 0.0.0.9027 (2024-04-05)

* New internal `exclude_cols_then_pivot_wider()` (#203). This is a
developer-oriented function to exclude irrelevant columns and duplicates from a
dataset, then pivot it to a wide format.

# tiltIndicatorAfter 0.0.0.9026 (2024-04-04)

BREAKING CHANGE

* New column `benchmark_tr_score_avg` replaces `benchmark_tr_score` in the output
at company level of `score_transition_risk()` (@kalashsinghal #199).

# tiltIndicatorAfter 0.0.0.9025 (2024-03-21)

* At product level, `profile_emissions()` now preserves missing benchmarks (#196).

# tiltIndicatorAfter 0.0.0.9024 (2024-03-15)

* `profile_emissions()` now preserves unmatched products (#193).

# tiltIndicatorAfter 0.0.0.9023 (2024-03-07)

* At company level `profile_emissions()` can now optionally output the column
`co2_avg` (@AnneSchoenauer #186). This is the mean of the `co2_footprint` for
each company. This control is via internal options (see
`?tiltIndicatorAfter_options`).

# tiltIndicatorAfter 0.0.0.9022 (2024-03-07)

* At product level `profile_emissions()` can now optionally output the licensed
column `co2_footprint` (#184). This control is via internal options (see
`?tiltIndicatorAfter_options`).

# tiltIndicatorAfter 0.0.0.9021 (2024-02-29)

* `profile_emissions()` and `profile_emissions_upstream()` now inform the amount
of noise added on average to the `co2*` columns. They now also allow controlling
the amount of noise, and demanding the licensed `min` and `max` columns that are
required to examine such noise before delivering data (#163). This control is
via internal options (see `?tiltIndicatorAfter_options`).

# tiltIndicatorAfter 0.0.0.9020 (2024-02-29)

NEW FUNCTIONS

* New function `score_transition_risk()` (@kalashsinghal #152).

NEW COLUMNS

* New columns `profile_ranking_avg` and `reduction_targets_avg` in the output at
company level of `profile_emissions*()` and `profile_sector*()`, respectively
(@kalashsinghal #164).
* New columns `co2e_lower` and `co2e_upper` in the output of `profile_emissions()`
and `profile_emissions_upstream()` -- both at product and company levels. This
columns include some noise that protects the privacy of the licensed CO2 values
(@kalashsinghal #155).
* New column `ei_geography` in the output of `profile_emissions()` and `profile_sector()`
  at product level (@kalashsinghal #148).
* New columns `ei_geography` and `ei_input_geography` in the output of
  `profile_emissions_upstream()` and `profile_sector_upstream()` at product
  level (@kalashsinghal #148).

BREAKING CHANGES

In practice these change should break nothing.

* Retire functions and datasets that have been deprecated for 8 weeks or more
(@kalashsinghal #157).
* The column `extra_rowid` was removed from all output files (@kalashsinghal
#141).

# tiltIndicatorAfter 0.0.0.9019 (2024-01-17)

* Use license GPLv3 (#140).

# tiltIndicatorAfter 0.0.0.9018 (2024-01-17)

In the output of all `profile_*()` functions these columns now have new names (#118):

* `PCTR_risk_category` -> `emission_profile`
* `PCTR_share` -> `emission_profile_share`
* `ICTR_risk_category` -> `emission_usptream_profile`
* `ICTR_share` -> `emission_usptream_profile_share`
* `PSTR_risk_category` -> `sector_profile`
* `PSTR_share` -> `sector_profile_share`
* `ISTR_risk_category` -> `sector_profile_upstream`
* `ISTR_share` -> `sector_profile_upstream_share`
* `sector` -> `sector_scenario`
* `subsector` -> `subsector_scenario`
* `profile_ranking` -> `reduction_targets`

# tiltIndicatorAfter 0.0.0.9017 (2024-01-16)

The following toy datasets are now deprecated in favor of equivalent data from
tiltToyData (#132).

* `ecoinvent_activities`
* `ecoinvent_inputs`
* `ep_companies`
* `isic_name`
* `matches_mapper`

# tiltIndicatorAfter 0.0.0.9016 (2023-12-20)

* Irrelevant columns in `europages_companies` and `ecoinvent_inputs` are no 
longer passed to the output (@kalashsinghal #105).

# tiltIndicatorAfter 0.0.0.9015 (2023-12-05)

The following functions are now deprecated in favor of the equivalent functions
of the new API (#96, see also [`?tiltIndicator::rename`](https://2degreesinvesting.github.io/tiltIndicator/reference/rename.html)).

* `prepare_ictr_company()`.
* `prepare_ictr_product()`.
* `prepare_istr_company()`.
* `prepare_istr_product()`.
* `prepare_pctr_company()`.
* `prepare_pctr_product()`.
* `prepare_pstr_company()`.
* `prepare_pstr_product()`.

# tiltIndicatorAfter 0.0.0.9014 (2023-12-04)

New arguments, new columns, and rename columns about `*isic_4digit*` (#86
@kalashsinghal):

* The functions `profile_sector()` and `profile_sector_upstream()` gain the
argument `isic_tilt`.

* In the output of `profile_emissions()` and `profile_emissions_upstream()` at
product level the columns `isic_name` and `input_isic_name` are now renamed to
`isic_4digit_name` and `input_isic_4digit_name`, respectively.

* The output of `profile_sector()` and `profile_sector_upstream()` at product
level gains the column `isic_4digit_name` and `input_isic_4digit_name`,
respectively.

# tiltIndicatorAfter 0.0.0.9013 (2023-12-04)

* The argument `ecoinvent_inputs` of `profile_emissions_upstream()` and
`profile_sector_upstream()` is now relocated next to other ecoinvent datasets,
and before the mappers (#91). This gives all `profile*()` functions a more
consistent structure.

# tiltIndicatorAfter 0.0.0.9012 (2023-12-04)

* Reexport `tiltIndicator::unest_product()` and `tiltIndicator::unnest_company()`
(#88).

# tiltIndicatorAfter 0.0.0.9011 (2023-12-01)

* New API wraps titlIndicator and outputs columns matching `*isic*` and `*sector*`
(#78).

# tiltIndicatorAfter 0.0.0.9010 (2023-11-30)

* Values of `*isic_4digit` are no longer padded to 4 digits (#81 @kalashsinghal).

# tiltIndicatorAfter 0.0.0.9009 (2023-09-24)

* Remove article showing how to enhance results (TiltDevProjectMGMT#126). This
duplicates an article in tiltIndicator.

# tiltIndicatorAfter 0.0.0.9008 (2023-09-24)

* Same as previous version.

# tiltIndicatorAfter 0.0.0.9007 (2023-09-24)

* Retire `pstr_company` and  `istr_company` as we now have more accurate toy datasets (#55).

# tiltIndicatorAfter 0.0.0.9006 (2023-09-24)

* `prepare_istr_company()` now accepts the output of `tiltIndicator::sector_profile_upstream()` 'as is' (#54).

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
