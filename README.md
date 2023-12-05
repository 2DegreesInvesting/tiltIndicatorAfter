
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
#> [1] '0.0.0.9014'

companies <- read_csv(toy_emissions_profile_any_companies())
products <- read_csv(toy_emissions_profile_products())

result <- profile_emissions(
  companies,
  products,
  # TODO: Move to tiltToyData
  europages_companies = tiltIndicatorAfter::ep_companies,
  ecoinvent_activities = tiltIndicatorAfter::ecoinvent_activities,
  ecoinvent_europages = tiltIndicatorAfter::matches_mapper |> head(100),
  isic_tilt = tiltIndicatorAfter::isic_tilt_mapper
)

result |> unnest_product()
#> # A tibble: 49 × 26
#>    companies_id     company_name country PCTR_risk_category benchmark ep_product
#>    <chr>            <chr>        <chr>   <chr>              <chr>     <chr>     
#>  1 fleischerei-sti… <NA>         <NA>    high               all       stove     
#>  2 fleischerei-sti… <NA>         <NA>    high               isic_4di… stove     
#>  3 fleischerei-sti… <NA>         <NA>    high               tilt_sec… stove     
#>  4 fleischerei-sti… <NA>         <NA>    high               unit      stove     
#>  5 fleischerei-sti… <NA>         <NA>    high               unit_isi… stove     
#>  6 fleischerei-sti… <NA>         <NA>    high               unit_til… stove     
#>  7 fleischerei-sti… <NA>         <NA>    high               all       oven      
#>  8 fleischerei-sti… <NA>         <NA>    medium             isic_4di… oven      
#>  9 fleischerei-sti… <NA>         <NA>    medium             tilt_sec… oven      
#> 10 fleischerei-sti… <NA>         <NA>    medium             unit      oven      
#> # ℹ 39 more rows
#> # ℹ 20 more variables: matched_activity_name <chr>,
#> #   matched_reference_product <chr>, unit <chr>, multi_match <lgl>,
#> #   matching_certainty <chr>, matching_certainty_company_average <chr>,
#> #   tilt_sector <chr>, tilt_subsector <chr>, isic_4digit <chr>,
#> #   isic_4digit_name <chr>, company_city <chr>, postcode <dbl>, address <chr>,
#> #   main_activity <chr>, activity_uuid_product_uuid <chr>, …

result |> unnest_company()
#> # A tibble: 129 × 11
#>    companies_id     company_name country PCTR_share PCTR_risk_category benchmark
#>    <chr>            <chr>        <chr>        <dbl> <lgl>              <lgl>    
#>  1 fleischerei-sti… <NA>         <NA>           1   NA                 NA       
#>  2 fleischerei-sti… <NA>         <NA>           0   NA                 NA       
#>  3 fleischerei-sti… <NA>         <NA>           0   NA                 NA       
#>  4 fleischerei-sti… <NA>         <NA>           0.5 NA                 NA       
#>  5 fleischerei-sti… <NA>         <NA>           0.5 NA                 NA       
#>  6 fleischerei-sti… <NA>         <NA>           0   NA                 NA       
#>  7 fleischerei-sti… <NA>         <NA>           0.5 NA                 NA       
#>  8 fleischerei-sti… <NA>         <NA>           0.5 NA                 NA       
#>  9 fleischerei-sti… <NA>         <NA>           0   NA                 NA       
#> 10 fleischerei-sti… <NA>         <NA>           0.5 NA                 NA       
#> # ℹ 119 more rows
#> # ℹ 5 more variables: matching_certainty_company_average <chr>,
#> #   company_city <chr>, postcode <dbl>, address <chr>, main_activity <chr>



inputs <- read_csv(toy_emissions_profile_upstream_products())

result <- profile_emissions_upstream(
  companies,
  inputs,
  # TODO: Move to tiltToyData
  europages_companies = tiltIndicatorAfter::ep_companies,
  ecoinvent_activities = tiltIndicatorAfter::ecoinvent_activities,
  ecoinvent_inputs = tiltIndicatorAfter::ecoinvent_inputs,
  ecoinvent_europages = tiltIndicatorAfter::matches_mapper |> head(100),
  isic_tilt = tiltIndicatorAfter::isic_tilt_mapper
)

result |> unnest_product()
#> # A tibble: 319 × 27
#>    companies_id     company_name country ICTR_risk_category benchmark ep_product
#>    <chr>            <chr>        <chr>   <chr>              <chr>     <chr>     
#>  1 fleischerei-sti… <NA>         <NA>    high               all       stove     
#>  2 fleischerei-sti… <NA>         <NA>    high               all       stove     
#>  3 fleischerei-sti… <NA>         <NA>    medium             all       stove     
#>  4 fleischerei-sti… <NA>         <NA>    high               all       stove     
#>  5 fleischerei-sti… <NA>         <NA>    high               all       stove     
#>  6 fleischerei-sti… <NA>         <NA>    low                all       stove     
#>  7 fleischerei-sti… <NA>         <NA>    low                all       stove     
#>  8 fleischerei-sti… <NA>         <NA>    high               all       stove     
#>  9 fleischerei-sti… <NA>         <NA>    high               input_is… stove     
#> 10 fleischerei-sti… <NA>         <NA>    high               input_is… stove     
#> # ℹ 309 more rows
#> # ℹ 21 more variables: matched_activity_name <chr>,
#> #   matched_reference_product <chr>, unit <chr>, multi_match <lgl>,
#> #   matching_certainty <chr>, matching_certainty_company_average <chr>,
#> #   input_name <chr>, input_unit <chr>, input_tilt_sector <chr>,
#> #   input_tilt_subsector <chr>, input_isic_4digit <chr>,
#> #   input_isic_4digit_name <chr>, company_city <chr>, postcode <dbl>, …

result |> unnest_company()
#> # A tibble: 127 × 11
#>    companies_id  company_name company_city country ICTR_share ICTR_risk_category
#>    <chr>         <chr>        <chr>        <chr>        <dbl> <chr>             
#>  1 fleischerei-… <NA>         <NA>         <NA>         0.571 high              
#>  2 fleischerei-… <NA>         <NA>         <NA>         0.214 medium            
#>  3 fleischerei-… <NA>         <NA>         <NA>         0.214 low               
#>  4 fleischerei-… <NA>         <NA>         <NA>         0.357 high              
#>  5 fleischerei-… <NA>         <NA>         <NA>         0.357 medium            
#>  6 fleischerei-… <NA>         <NA>         <NA>         0.286 low               
#>  7 fleischerei-… <NA>         <NA>         <NA>         0.429 high              
#>  8 fleischerei-… <NA>         <NA>         <NA>         0.357 medium            
#>  9 fleischerei-… <NA>         <NA>         <NA>         0.214 low               
#> 10 fleischerei-… <NA>         <NA>         <NA>         0.429 high              
#> # ℹ 117 more rows
#> # ℹ 5 more variables: benchmark <chr>,
#> #   matching_certainty_company_average <chr>, postcode <dbl>, address <chr>,
#> #   main_activity <chr>
```
