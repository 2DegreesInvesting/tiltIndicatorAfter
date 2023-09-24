
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

packageVersion("tiltIndicatorAfter")
#> [1] '0.0.0.9006'

prepare_pctr_product(
  pctr_product,
  ep_companies,
  ecoinvent_activities,
  matches_mapper,
  isic_tilt_mapper
)
#> # A tibble: 25 × 21
#>    companies_id company_name country PCTR_risk_category benchmark     ep_product
#>    <chr>        <chr>        <chr>   <chr>              <chr>         <chr>     
#>  1 id3          company C    austria <NA>               <NA>          <NA>      
#>  2 id1          company A    germany high               all           building …
#>  3 id1          company A    germany medium             isic_sec      building …
#>  4 id1          company A    germany low                tilt_sec      building …
#>  5 id1          company A    germany high               unit          building …
#>  6 id1          company A    germany medium             unit_isic_sec building …
#>  7 id1          company A    germany high               unit_tilt_sec building …
#>  8 id1          company A    germany medium             all           machining 
#>  9 id1          company A    germany medium             isic_sec      machining 
#> 10 id1          company A    germany medium             tilt_sec      machining 
#> # ℹ 15 more rows
#> # ℹ 15 more variables: matched_activity_name <chr>,
#> #   matched_reference_product <chr>, unit <chr>, multi_match <chr>,
#> #   matching_certainty <chr>, matching_certainty_company_average <chr>,
#> #   tilt_sector <chr>, tilt_subsector <chr>, isic_4digit <chr>,
#> #   isic_name <chr>, company_city <chr>, postcode <dbl>, address <chr>,
#> #   main_activity <chr>, activity_uuid_product_uuid <chr>

prepare_pctr_company(
  pctr_company,
  pctr_product,
  ep_companies,
  ecoinvent_activities,
  matches_mapper,
  isic_tilt_mapper
)
#> # A tibble: 37 × 11
#>    companies_id company_name country PCTR_share PCTR_risk_category benchmark
#>    <chr>        <chr>        <chr>        <dbl> <chr>              <chr>    
#>  1 id1          company A    germany        0.5 high               all      
#>  2 id1          company A    germany        0.5 medium             all      
#>  3 id1          company A    germany        0   low                all      
#>  4 id1          company A    germany        0   high               isic_sec 
#>  5 id1          company A    germany        1   medium             isic_sec 
#>  6 id1          company A    germany        0   low                isic_sec 
#>  7 id1          company A    germany        0   high               tilt_sec 
#>  8 id1          company A    germany        0.5 medium             tilt_sec 
#>  9 id1          company A    germany        0.5 low                tilt_sec 
#> 10 id1          company A    germany        1   high               unit     
#> # ℹ 27 more rows
#> # ℹ 5 more variables: matching_certainty_company_average <chr>,
#> #   company_city <chr>, postcode <dbl>, address <chr>, main_activity <chr>
```
