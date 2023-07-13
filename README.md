
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
#> [1] '0.0.0.9000'

ep_companies
#> # A tibble: 3 × 7
#>   company_name country company_city postcode address  main_activity companies_id
#>   <chr>        <chr>   <chr>           <dbl> <chr>    <chr>         <chr>       
#> 1 company C    austria voitsberg        8570 ruhmann… service prov… id3         
#> 2 company B    germany berlin          13353 sprenge… distributor   id2         
#> 3 company A    germany frankfurt       60316 wittels… manufacturer… id1

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
#> # A tibble: 100 × 5
#>    activity_uuid_product_…¹ activity_name geography reference_product_name unit 
#>    <chr>                    <chr>         <chr>     <chr>                  <chr>
#>  1 dabb3812-eee9-5d2b-bc23… bark chips, … CH        residual hardwood, wet m3   
#>  2 3b34f2a3-abfb-5681-ac78… market for n… GLO       nitrous oxide          kg   
#>  3 3a2ab192-109a-5fa4-b9d9… market for s… CH        sawdust, wet, measure… kg   
#>  4 16e0e4f7-a44f-55d5-ae85… market for s… CH        sewage sludge, 70% wa… kg   
#>  5 732c6740-c4fb-598d-89a0… phenolic res… RER       phenolic resin         kg   
#>  6 32ab1519-ba6d-5432-9c5d… treatment of… CN        sewage sludge, 97% wa… kg   
#>  7 d08ed49a-25fd-5766-bafc… heat and pow… US-WECC   electricity, high vol… kWh  
#>  8 6632b6ca-fdb9-5d16-a1b1… treatment of… Europe w… organic nitrogen fert… kg   
#>  9 a73e89c1-abd9-54a1-8c44… catch crop g… CH        ryegrass silage        kg   
#> 10 da6fd7f1-4ee6-5491-81a9… nuclear fuel… RoW       nuclear fuel element,… kg   
#> # ℹ 90 more rows
#> # ℹ abbreviated name: ¹​activity_uuid_product_uuid

ecoinvent_inputs
#> # A tibble: 52 × 3
#>    input_activity_uuid_product_uuid             exchange_name exchange_unit_name
#>    <chr>                                        <chr>         <chr>             
#>  1 7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44c… aluminium, w… kg                
#>  2 3b190359-a32e-5294-af63-983f38ce6525_759b89… electricity,… kWh               
#>  3 62b803ad-e3ff-516b-947d-f08eea52c702_fbb039… copper, cath… kg                
#>  4 372a1991-e0af-5fbf-8611-295a535373ad_9ba482… reinforcing … kg                
#>  5 531db396-1434-54e5-b6c4-c2b4323471cb_751b5e… stone wool, … kg                
#>  6 c93a2afc-7e58-50b6-af0e-586f71a3de0e_bfd577… waste minera… kg                
#>  7 3a29c9e0-4183-588d-95a9-502b55d2c513_bfd577… waste minera… kg                
#>  8 2330b528-6e31-5a99-9801-73834e2a835f_6f2eb4… waste wood, … kg                
#>  9 79d6450d-f9ad-5619-89c3-05c8d7622af3_b0f4c2… diesel, burn… MJ                
#> 10 044043d2-bdfc-55f1-9d2d-e8431d5266c7_8cb650… steel, low-a… kg                
#> # ℹ 42 more rows

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
  prepare_pctr_product(ep_companies, ecoinvent_activities, matches_mapper)
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
  prepare_pctr_company(pctr_product, ep_companies, ecoinvent_activities, matches_mapper)
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
