
# tiltIndicatorAfter

The goal of tiltIndicatorAfter is to conduct post-processing of four
indicators created from the tiltIndicator package. The post-processing
process cleans the useless data and adds additional columns. The
processed output from the tiltIndicatorAfter package is the final output
for the user.

This repository hosts only public code and may only show only fake data.

## Installation

You can install the development version of tiltIndicator from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("2DegreesInvesting/tiltIndicatorAfter")
```

## Example

``` r
library(tiltIndicatorAfter)
library(tiltToyData)
library(readr, warn.conflicts = FALSE)

options(readr.show_col_types = FALSE)

packageVersion("tiltIndicatorAfter")
#> [1] '0.0.0.9016'

companies <- read_csv(toy_emissions_profile_any_companies())
products <- read_csv(toy_emissions_profile_products())
#> Warning: `toy_emissions_profile_products()` was deprecated in tiltToyData 0.0.0.9009.
#> ℹ Please use `toy_emissions_profile_products_ecoinvent()` instead.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.

result <- profile_emissions(
  companies,
  products,
  # TODO: Move to tiltToyData
  europages_companies = read_csv(toy_europages_companies()),
  ecoinvent_activities = tiltIndicatorAfter::ecoinvent_activities,
  ecoinvent_europages = tiltIndicatorAfter::matches_mapper |> head(100),
  isic = tiltIndicatorAfter::isic_name
)

result |> unnest_product()
#> # A tibble: 72 × 26
#>    companies_id     company_name country PCTR_risk_category benchmark ep_product
#>    <chr>            <chr>        <chr>   <chr>              <lgl>     <chr>     
#>  1 antimonarchy_ca… <NA>         <NA>    <NA>               NA        <NA>      
#>  2 celestial_loveb… <NA>         <NA>    <NA>               NA        <NA>      
#>  3 nonphilosophica… <NA>         <NA>    <NA>               NA        <NA>      
#>  4 asteria_megalot… <NA>         <NA>    <NA>               NA        <NA>      
#>  5 quasifaithful_a… <NA>         <NA>    <NA>               NA        <NA>      
#>  6 spectacular_ame… <NA>         <NA>    <NA>               NA        <NA>      
#>  7 contrite_silkwo… <NA>         <NA>    <NA>               NA        <NA>      
#>  8 harmless_owlbut… <NA>         <NA>    <NA>               NA        <NA>      
#>  9 fascist_maiasau… <NA>         <NA>    <NA>               NA        <NA>      
#> 10 charismatic_isl… <NA>         <NA>    <NA>               NA        <NA>      
#> # ℹ 62 more rows
#> # ℹ 20 more variables: matched_activity_name <chr>,
#> #   matched_reference_product <chr>, unit <chr>, multi_match <lgl>,
#> #   matching_certainty <chr>, matching_certainty_company_average <chr>,
#> #   tilt_sector <chr>, tilt_subsector <chr>, isic_4digit <chr>,
#> #   isic_4digit_name <chr>, company_city <chr>, postcode <dbl>, address <chr>,
#> #   main_activity <chr>, activity_uuid_product_uuid <chr>, …

result |> unnest_company()
#> # A tibble: 72 × 11
#>    companies_id     company_name country PCTR_share PCTR_risk_category benchmark
#>    <chr>            <chr>        <chr>        <dbl> <lgl>              <lgl>    
#>  1 antimonarchy_ca… <NA>         <NA>            NA NA                 NA       
#>  2 celestial_loveb… <NA>         <NA>            NA NA                 NA       
#>  3 nonphilosophica… <NA>         <NA>            NA NA                 NA       
#>  4 asteria_megalot… <NA>         <NA>            NA NA                 NA       
#>  5 quasifaithful_a… <NA>         <NA>            NA NA                 NA       
#>  6 spectacular_ame… <NA>         <NA>            NA NA                 NA       
#>  7 contrite_silkwo… <NA>         <NA>            NA NA                 NA       
#>  8 harmless_owlbut… <NA>         <NA>            NA NA                 NA       
#>  9 fascist_maiasau… <NA>         <NA>            NA NA                 NA       
#> 10 charismatic_isl… <NA>         <NA>            NA NA                 NA       
#> # ℹ 62 more rows
#> # ℹ 5 more variables: matching_certainty_company_average <chr>,
#> #   company_city <chr>, postcode <dbl>, address <chr>, main_activity <chr>



inputs <- read_csv(toy_emissions_profile_upstream_products())
#> Warning: `toy_emissions_profile_upstream_products()` was deprecated in tiltToyData
#> 0.0.0.9009.
#> ℹ Please use `toy_emissions_profile_upstream_products_ecoinvent()` instead.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.

result <- profile_emissions_upstream(
  companies,
  inputs,
  # TODO: Move to tiltToyData
  europages_companies = read_csv(toy_europages_companies()),
  ecoinvent_activities = tiltIndicatorAfter::ecoinvent_activities,
  ecoinvent_inputs = tiltIndicatorAfter::ecoinvent_inputs,
  ecoinvent_europages = tiltIndicatorAfter::matches_mapper |> head(100),
  isic = tiltIndicatorAfter::isic_name
)

result |> unnest_product()
#> # A tibble: 72 × 27
#>    companies_id     company_name country ICTR_risk_category benchmark ep_product
#>    <chr>            <chr>        <chr>   <chr>              <lgl>     <chr>     
#>  1 antimonarchy_ca… <NA>         <NA>    <NA>               NA        <NA>      
#>  2 celestial_loveb… <NA>         <NA>    <NA>               NA        <NA>      
#>  3 nonphilosophica… <NA>         <NA>    <NA>               NA        <NA>      
#>  4 asteria_megalot… <NA>         <NA>    <NA>               NA        <NA>      
#>  5 quasifaithful_a… <NA>         <NA>    <NA>               NA        <NA>      
#>  6 spectacular_ame… <NA>         <NA>    <NA>               NA        <NA>      
#>  7 contrite_silkwo… <NA>         <NA>    <NA>               NA        <NA>      
#>  8 harmless_owlbut… <NA>         <NA>    <NA>               NA        <NA>      
#>  9 fascist_maiasau… <NA>         <NA>    <NA>               NA        <NA>      
#> 10 charismatic_isl… <NA>         <NA>    <NA>               NA        <NA>      
#> # ℹ 62 more rows
#> # ℹ 21 more variables: matched_activity_name <chr>,
#> #   matched_reference_product <chr>, unit <chr>, multi_match <lgl>,
#> #   matching_certainty <chr>, matching_certainty_company_average <chr>,
#> #   input_name <chr>, input_unit <chr>, input_tilt_sector <chr>,
#> #   input_tilt_subsector <chr>, input_isic_4digit <chr>,
#> #   input_isic_4digit_name <chr>, company_city <chr>, postcode <dbl>, …

result |> unnest_company()
#> # A tibble: 72 × 11
#>    companies_id  company_name company_city country ICTR_share ICTR_risk_category
#>    <chr>         <chr>        <chr>        <chr>        <dbl> <lgl>             
#>  1 antimonarchy… <NA>         <NA>         <NA>            NA NA                
#>  2 celestial_lo… <NA>         <NA>         <NA>            NA NA                
#>  3 nonphilosoph… <NA>         <NA>         <NA>            NA NA                
#>  4 asteria_mega… <NA>         <NA>         <NA>            NA NA                
#>  5 quasifaithfu… <NA>         <NA>         <NA>            NA NA                
#>  6 spectacular_… <NA>         <NA>         <NA>            NA NA                
#>  7 contrite_sil… <NA>         <NA>         <NA>            NA NA                
#>  8 harmless_owl… <NA>         <NA>         <NA>            NA NA                
#>  9 fascist_maia… <NA>         <NA>         <NA>            NA NA                
#> 10 charismatic_… <NA>         <NA>         <NA>            NA NA                
#> # ℹ 62 more rows
#> # ℹ 5 more variables: benchmark <lgl>,
#> #   matching_certainty_company_average <chr>, postcode <dbl>, address <chr>,
#> #   main_activity <chr>
```
