<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

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
