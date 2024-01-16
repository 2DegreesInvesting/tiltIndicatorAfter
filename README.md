
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
products <- read_csv(toy_emissions_profile_products_ecoinvent())

result <- profile_emissions(
  companies,
  products,
  # TODO: Move to tiltToyData
  europages_companies = tiltIndicatorAfter::ep_companies,
  ecoinvent_activities = tiltIndicatorAfter::ecoinvent_activities,
  ecoinvent_europages = tiltIndicatorAfter::matches_mapper |> head(100),
  isic = tiltIndicatorAfter::isic_name
)

result |> unnest_product()
#> # A tibble: 2,736 × 26
#>    companies_id     company_name country PCTR_risk_category benchmark ep_product
#>    <chr>            <chr>        <chr>   <chr>              <chr>     <chr>     
#>  1 antimonarchy_ca… <NA>         <NA>    low                all       tent      
#>  2 antimonarchy_ca… <NA>         <NA>    high               all       tent      
#>  3 antimonarchy_ca… <NA>         <NA>    high               all       tent      
#>  4 antimonarchy_ca… <NA>         <NA>    medium             all       tent      
#>  5 antimonarchy_ca… <NA>         <NA>    low                all       tent      
#>  6 antimonarchy_ca… <NA>         <NA>    medium             all       tent      
#>  7 antimonarchy_ca… <NA>         <NA>    medium             isic_4di… tent      
#>  8 antimonarchy_ca… <NA>         <NA>    high               isic_4di… tent      
#>  9 antimonarchy_ca… <NA>         <NA>    low                isic_4di… tent      
#> 10 antimonarchy_ca… <NA>         <NA>    high               isic_4di… tent      
#> # ℹ 2,726 more rows
#> # ℹ 20 more variables: matched_activity_name <chr>,
#> #   matched_reference_product <chr>, unit <chr>, multi_match <lgl>,
#> #   matching_certainty <chr>, matching_certainty_company_average <chr>,
#> #   tilt_sector <chr>, tilt_subsector <chr>, isic_4digit <chr>,
#> #   isic_4digit_name <chr>, company_city <chr>, postcode <dbl>, address <chr>,
#> #   main_activity <chr>, activity_uuid_product_uuid <chr>, …

result |> unnest_company()
#> # A tibble: 1,296 × 11
#>    companies_id     company_name country PCTR_share PCTR_risk_category benchmark
#>    <chr>            <chr>        <chr>        <dbl> <lgl>              <lgl>    
#>  1 antimonarchy_ca… <NA>         <NA>         0.333 NA                 NA       
#>  2 antimonarchy_ca… <NA>         <NA>         0.333 NA                 NA       
#>  3 antimonarchy_ca… <NA>         <NA>         0.333 NA                 NA       
#>  4 antimonarchy_ca… <NA>         <NA>         0.5   NA                 NA       
#>  5 antimonarchy_ca… <NA>         <NA>         0.167 NA                 NA       
#>  6 antimonarchy_ca… <NA>         <NA>         0.333 NA                 NA       
#>  7 antimonarchy_ca… <NA>         <NA>         0.5   NA                 NA       
#>  8 antimonarchy_ca… <NA>         <NA>         0     NA                 NA       
#>  9 antimonarchy_ca… <NA>         <NA>         0.5   NA                 NA       
#> 10 antimonarchy_ca… <NA>         <NA>         0.5   NA                 NA       
#> # ℹ 1,286 more rows
#> # ℹ 5 more variables: matching_certainty_company_average <chr>,
#> #   company_city <chr>, postcode <dbl>, address <chr>, main_activity <chr>



inputs <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())

result <- profile_emissions_upstream(
  companies,
  inputs,
  # TODO: Move to tiltToyData
  europages_companies = tiltIndicatorAfter::ep_companies,
  ecoinvent_activities = tiltIndicatorAfter::ecoinvent_activities,
  ecoinvent_inputs = tiltIndicatorAfter::ecoinvent_inputs,
  ecoinvent_europages = tiltIndicatorAfter::matches_mapper |> head(100),
  isic = tiltIndicatorAfter::isic_name
)

result |> unnest_product()
#> # A tibble: 4,140 × 27
#>    companies_id     company_name country ICTR_risk_category benchmark ep_product
#>    <chr>            <chr>        <chr>   <chr>              <chr>     <chr>     
#>  1 antimonarchy_ca… <NA>         <NA>    medium             all       tent      
#>  2 antimonarchy_ca… <NA>         <NA>    low                all       tent      
#>  3 antimonarchy_ca… <NA>         <NA>    low                all       tent      
#>  4 antimonarchy_ca… <NA>         <NA>    high               all       tent      
#>  5 antimonarchy_ca… <NA>         <NA>    medium             all       tent      
#>  6 antimonarchy_ca… <NA>         <NA>    low                all       tent      
#>  7 antimonarchy_ca… <NA>         <NA>    medium             input_is… tent      
#>  8 antimonarchy_ca… <NA>         <NA>    medium             input_is… tent      
#>  9 antimonarchy_ca… <NA>         <NA>    low                input_is… tent      
#> 10 antimonarchy_ca… <NA>         <NA>    high               input_is… tent      
#> # ℹ 4,130 more rows
#> # ℹ 21 more variables: matched_activity_name <chr>,
#> #   matched_reference_product <chr>, unit <chr>, multi_match <lgl>,
#> #   matching_certainty <chr>, matching_certainty_company_average <chr>,
#> #   input_name <chr>, input_unit <chr>, input_tilt_sector <chr>,
#> #   input_tilt_subsector <chr>, input_isic_4digit <chr>,
#> #   input_isic_4digit_name <chr>, company_city <chr>, postcode <dbl>, …

result |> unnest_company()
#> # A tibble: 1,296 × 11
#>    companies_id  company_name company_city country ICTR_share ICTR_risk_category
#>    <chr>         <chr>        <chr>        <chr>        <dbl> <chr>             
#>  1 antimonarchy… <NA>         <NA>         <NA>         0.167 high              
#>  2 antimonarchy… <NA>         <NA>         <NA>         0.333 medium            
#>  3 antimonarchy… <NA>         <NA>         <NA>         0.5   low               
#>  4 antimonarchy… <NA>         <NA>         <NA>         0.167 high              
#>  5 antimonarchy… <NA>         <NA>         <NA>         0.5   medium            
#>  6 antimonarchy… <NA>         <NA>         <NA>         0.333 low               
#>  7 antimonarchy… <NA>         <NA>         <NA>         0.333 high              
#>  8 antimonarchy… <NA>         <NA>         <NA>         0.167 medium            
#>  9 antimonarchy… <NA>         <NA>         <NA>         0.5   low               
#> 10 antimonarchy… <NA>         <NA>         <NA>         0.333 high              
#> # ℹ 1,286 more rows
#> # ℹ 5 more variables: benchmark <chr>,
#> #   matching_certainty_company_average <chr>, postcode <dbl>, address <chr>,
#> #   main_activity <chr>
```
