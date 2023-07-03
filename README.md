
# tiltIndicatorAfter

The goal of tiltIndicatorAfter is to conduct post-processing of four
indicators created from the tiltIndicator package. The post-processing
process cleans the data, adds additional columns, and creates subsets
for Netherlands and 20 sample companies. The processed output from the
tiltIndicatorAfter package is the final output for the user.

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
#> [1] '0.0.0.9000'

companies
#> # A tibble: 228 × 11
#>    companies_id company_name country company_city postcode address main_activity
#>    <chr>        <chr>        <chr>   <chr>           <dbl> <chr>   <chr>        
#>  1 id3          company C    austria voitsberg        8570 ruhman… service prov…
#>  2 id3          company C    austria voitsberg        8570 ruhman… service prov…
#>  3 id3          company C    austria voitsberg        8570 ruhman… service prov…
#>  4 id3          company C    austria voitsberg        8570 ruhman… service prov…
#>  5 id3          company C    austria voitsberg        8570 ruhman… service prov…
#>  6 id3          company C    austria voitsberg        8570 ruhman… service prov…
#>  7 id3          company C    austria voitsberg        8570 ruhman… service prov…
#>  8 id3          company C    austria voitsberg        8570 ruhman… service prov…
#>  9 id3          company C    austria voitsberg        8570 ruhman… service prov…
#> 10 id2          company B    germany berlin          13353 spreng… distributor  
#> # ℹ 218 more rows
#> # ℹ 4 more variables: group <chr>, sector <chr>, subsector <chr>,
#> #   clustered <chr>

matches_mapper
#> # A tibble: 23,270 × 8
#>    ep_id      country main_activity clustered activity_uuid_produc…¹ multi_match
#>    <chr>      <chr>   <chr>         <chr>     <chr>                  <lgl>      
#>  1 0b0ae0f9e… germany service prov… air puri… bcdcd9f2-a3d9-58a3-b2… TRUE       
#>  2 0b0ae0f9e… germany service prov… air puri… 68a453fd-c49c-5358-9e… TRUE       
#>  3 0dde317dd… france  missing       aircraft… d7739cef-e1e3-5084-97… TRUE       
#>  4 0dde317dd… france  missing       aircraft… b2559f83-c1b9-51a9-a2… TRUE       
#>  5 0dde317dd… germany missing       aircraft… d7739cef-e1e3-5084-97… TRUE       
#>  6 0dde317dd… germany missing       aircraft… b2559f83-c1b9-51a9-a2… TRUE       
#>  7 0dde317dd… germany service prov… aircraft… d7739cef-e1e3-5084-97… TRUE       
#>  8 0dde317dd… germany service prov… aircraft… b2559f83-c1b9-51a9-a2… TRUE       
#>  9 f622bd01b… france  service prov… aircraft… 39ff049a-3abf-51e6-a7… TRUE       
#> 10 f622bd01b… france  service prov… aircraft… 1c0ee497-bffd-55f5-99… TRUE       
#> # ℹ 23,260 more rows
#> # ℹ abbreviated name: ¹​activity_uuid_product_uuid
#> # ℹ 2 more variables: completion <chr>, category <chr>

ecoinvent_activities
#> # A tibble: 21,238 × 8
#>    activity_uuid_product_uuid     activity_name geography reference_product_name
#>    <chr>                          <chr>         <chr>     <chr>                 
#>  1 dabb3812-eee9-5d2b-bc23-0f9a3… bark chips, … CH        residual hardwood, wet
#>  2 3b34f2a3-abfb-5681-ac78-60c8f… market for n… GLO       nitrous oxide         
#>  3 3a2ab192-109a-5fa4-b9d9-7ed54… market for s… CH        sawdust, wet, measure…
#>  4 16e0e4f7-a44f-55d5-ae85-b2a61… market for s… CH        sewage sludge, 70% wa…
#>  5 732c6740-c4fb-598d-89a0-f8d0a… phenolic res… RER       phenolic resin        
#>  6 32ab1519-ba6d-5432-9c5d-c82d2… treatment of… CN        sewage sludge, 97% wa…
#>  7 d08ed49a-25fd-5766-bafc-3cb50… heat and pow… US-WECC   electricity, high vol…
#>  8 6632b6ca-fdb9-5d16-a1b1-599bb… treatment of… Europe w… organic nitrogen fert…
#>  9 a73e89c1-abd9-54a1-8c44-17547… catch crop g… CH        ryegrass silage       
#> 10 da6fd7f1-4ee6-5491-81a9-2e42c… nuclear fuel… RoW       nuclear fuel element,…
#> # ℹ 21,228 more rows
#> # ℹ 4 more variables: isic_4digit <chr>, isic_4digit_name_ecoinvent <chr>,
#> #   isic_section <chr>, unit <chr>

ecoinvent_inputs
#> # A tibble: 246,004 × 8
#>    activity_uuid_produc…¹ activity_name product_geography input_activity_uuid_…²
#>    <chr>                  <chr>         <chr>             <chr>                 
#>  1 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               b1649f21-88de-53a4-a5…
#>  2 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               9f850d21-3a8f-5954-ba…
#>  3 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               b114b449-7b44-539d-b5…
#>  4 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               023ad034-21ce-56b0-b6…
#>  5 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               9158a1e6-3c02-5113-bf…
#>  6 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               7ac71fd7-a65b-5f2c-92…
#>  7 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               41123892-ac9f-50d9-95…
#>  8 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               9f7ffd08-aa89-59a3-aa…
#>  9 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               d5039cfa-00d8-5663-b1…
#> 10 61acb392-9dda-594b-bb… [sulfonyl]ur… RoW               40b6e556-9ee6-57c5-92…
#> # ℹ 245,994 more rows
#> # ℹ abbreviated names: ¹​activity_uuid_product_uuid,
#> #   ²​input_activity_uuid_product_uuid
#> # ℹ 4 more variables: exchange_name <chr>, input_geography <chr>,
#> #   exchange_unit_name <chr>, exchange_amount <dbl>

# PCTR

pctr_product
#> # A tibble: 30 × 6
#>    companies_id grouped_by    risk_category clustered     activity_uuid_produc…¹
#>    <chr>        <chr>         <chr>         <chr>         <chr>                 
#>  1 id1          all           high          building con… ebd4dddf-9f74-5fd1-89…
#>  2 id1          isic_sec      medium        building con… ebd4dddf-9f74-5fd1-89…
#>  3 id1          tilt_sec      low           building con… ebd4dddf-9f74-5fd1-89…
#>  4 id1          unit          high          building con… ebd4dddf-9f74-5fd1-89…
#>  5 id1          unit_isic_sec medium        building con… ebd4dddf-9f74-5fd1-89…
#>  6 id1          unit_tilt_sec high          building con… ebd4dddf-9f74-5fd1-89…
#>  7 id1          all           medium        machining     6fcaa508-05b7-5a7b-98…
#>  8 id1          isic_sec      medium        machining     6fcaa508-05b7-5a7b-98…
#>  9 id1          tilt_sec      medium        machining     6fcaa508-05b7-5a7b-98…
#> 10 id1          unit          high          machining     6fcaa508-05b7-5a7b-98…
#> # ℹ 20 more rows
#> # ℹ abbreviated name: ¹​activity_uuid_product_uuid
#> # ℹ 1 more variable: co2_footprint <dbl>

pctr_product_final <- pctr_product |>
  prepare_pctr_product(companies, ecoinvent_activities, matches_mapper)
pctr_product_final
#> # A tibble: 25 × 17
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
#> # ℹ 11 more variables: matched_activity_name <chr>,
#> #   matched_reference_product <chr>, unit <chr>, multi_match <chr>,
#> #   matching_certainty <chr>, matching_certainty_company_average <chr>,
#> #   company_city <chr>, postcode <dbl>, address <chr>, main_activity <chr>,
#> #   activity_uuid_product_uuid <chr>

pctr_company
#> # A tibble: 54 × 4
#>    companies_id grouped_by risk_category value
#>    <chr>        <chr>      <chr>         <dbl>
#>  1 id1          all        high            0.5
#>  2 id1          all        medium          0.5
#>  3 id1          all        low             0  
#>  4 id1          isic_sec   high            0  
#>  5 id1          isic_sec   medium          1  
#>  6 id1          isic_sec   low             0  
#>  7 id1          tilt_sec   high            0  
#>  8 id1          tilt_sec   medium          0.5
#>  9 id1          tilt_sec   low             0.5
#> 10 id1          unit       high            1  
#> # ℹ 44 more rows

pctr_company_final <- pctr_company |> 
  prepare_pctr_company(pctr_product, companies, ecoinvent_activities, matches_mapper)
pctr_company_final
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
