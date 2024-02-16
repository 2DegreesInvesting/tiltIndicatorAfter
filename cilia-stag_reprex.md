``` r
library(readr)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
devtools::load_all(".")
#> ℹ Loading tiltIndicatorAfter
options(width = 500)

options(readr.show_col_types = FALSE)
toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
toy_emissions_profile_upstream_products_ecoinvent <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
toy_europages_companies <- read_csv(toy_europages_companies())
toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
toy_isic_name <- read_csv(toy_isic_name())

emissions_profile <- profile_emissions(
  companies = toy_emissions_profile_any_companies,
  co2 = toy_emissions_profile_products_ecoinvent,
  europages_companies = toy_europages_companies,
  ecoinvent_activities = toy_ecoinvent_activities,
  ecoinvent_europages = toy_ecoinvent_europages,
  isic = toy_isic_name)

emissions_profile_upstream <- profile_emissions_upstream(
  companies = toy_emissions_profile_any_companies,
  co2 = toy_emissions_profile_upstream_products_ecoinvent,
  europages_companies = toy_europages_companies,
  ecoinvent_activities = toy_ecoinvent_activities,
  ecoinvent_inputs = toy_ecoinvent_inputs,
  ecoinvent_europages = toy_ecoinvent_europages,
  isic = toy_isic_name)

emissions_profile_at_product_level <- unnest_product(emissions_profile)
emissions_profile_at_company_level <- unnest_company(emissions_profile)
emissions_profile_upstream_at_product_level <- unnest_product(emissions_profile_upstream)
emissions_profile_upstream_at_company_level <- unnest_company(emissions_profile_upstream)

emissions_profile_at_product_level
#> # A tibble: 456 × 25
#>    companies_id                       company_name                       country emission_profile benchmark        ep_product               matched_activity_name                                         matched_reference_product                          co2e_lower co2e_upper unit  multi_match matching_certainty matching_certainty_company_average tilt_sector  tilt_subsector  isic_4digit isic_4digit_name company_city postcode address main_activity activity_uuid_produc…¹ profile_ranking ei_geography
#>    <chr>                              <chr>                              <chr>   <chr>            <chr>            <chr>                    <chr>                                                         <chr>                                                   <dbl>      <dbl> <chr> <lgl>       <chr>              <chr>                              <chr>        <chr>           <chr>       <chr>            <chr>        <chr>    <chr>   <chr>         <chr>                            <dbl> <chr>       
#>  1 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high             all              tent                     market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected   194.           409. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#>  2 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high             isic_4digit      tent                     market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected     0.0840       811. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#>  3 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high             tilt_sector      tent                     market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected     5.15         834. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#>  4 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high             unit             tent                     market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected     9.76         707. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#>  5 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high             unit_isic_4digit tent                     market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected     0.364        366. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#>  6 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high             unit_tilt_sector tent                     market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected     7.08         689. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#>  7 skarn_gallinule                    skarn_gallinule                    austria high             all              sheds, construction site market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected   194.           409. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wiener neud… 2355     iz nö-… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#>  8 skarn_gallinule                    skarn_gallinule                    austria high             isic_4digit      sheds, construction site market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected     0.0840       811. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wiener neud… 2355     iz nö-… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#>  9 skarn_gallinule                    skarn_gallinule                    austria high             tilt_sector      sheds, construction site market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected     5.15         834. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wiener neud… 2355     iz nö-… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#> 10 skarn_gallinule                    skarn_gallinule                    austria high             unit             sheds, construction site market for shed, large, wood, non-insulated, fire-unprotected shed, large, wood, non-insulated, fire-unprotected     9.76         707. m2    FALSE       low                low                                construction construction r… '4100'      Construction of… wiener neud… 2355     iz nö-… wholesaler    76269c17-78d6-420b-99…               1 tilt_world  
#> # ℹ 446 more rows
#> # ℹ abbreviated name: ¹​activity_uuid_product_uuid

emissions_profile_at_company_level
#> # A tibble: 1,296 × 13
#>    companies_id                       company_name                       country emission_profile_share emission_profile benchmark   co2e_lower co2e_upper matching_certainty_company_average company_city postcode address                                  main_activity
#>    <chr>                              <chr>                              <chr>                    <dbl> <chr>            <chr>            <dbl>      <dbl> <chr>                              <chr>        <chr>    <chr>                                    <chr>        
#>  1 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      1 high             all           194.         409.   low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  2 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      0 medium           all             8.12        19.0  low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  3 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      0 low              all             0.337        1.95 low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  4 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      1 high             isic_4digit     0.0840     811.   low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  5 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      0 medium           isic_4digit    NA           NA    low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  6 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      0 low              isic_4digit    NA           NA    low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  7 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      1 high             tilt_sector     5.15       834.   low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  8 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      0 medium           tilt_sector     0.606        1.14 low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  9 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      0 low              tilt_sector    NA           NA    low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#> 10 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria                      1 high             unit            9.76       707.   low                                wilhelmsburg 3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#> # ℹ 1,286 more rows

emissions_profile_upstream_at_product_level
#> # A tibble: 690 × 28
#>    companies_id                       company_name                       country emission_upstream_profile benchmark                    ep_product           matched_activity_name matched_reference_pr…¹ co2e_lower co2e_upper unit  multi_match matching_certainty matching_certainty_c…² input_name input_unit input_tilt_sector input_tilt_subsector input_isic_4digit input_isic_4digit_name company_city postcode address main_activity activity_uuid_produc…³ profile_ranking ei_input_geography ei_geography
#>    <chr>                              <chr>                              <chr>   <chr>                     <chr>                        <chr>                <chr>                 <chr>                       <dbl>      <dbl> <chr> <lgl>       <chr>              <chr>                  <chr>      <chr>      <chr>             <chr>                <chr>             <chr>                  <chr>        <chr>    <chr>   <chr>         <chr>                            <dbl> <chr>              <chr>       
#>  1 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high                      all                          tent                 market for shed, lar… shed, large, wood, no…     3.36      7.72e15 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…           0.938 tilt_land          tilt_world  
#>  2 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high                      input_isic_4digit            tent                 market for shed, lar… shed, large, wood, no…     0.0990    9.38e15 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…           1     tilt_land          tilt_world  
#>  3 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high                      input_tilt_sector            tent                 market for shed, lar… shed, large, wood, no…     0.669     7.42e15 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…           1     tilt_land          tilt_world  
#>  4 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high                      input_unit                   tent                 market for shed, lar… shed, large, wood, no…     0.673     2.34e16 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…           1     tilt_land          tilt_world  
#>  5 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high                      input_unit_input_isic_4digit tent                 market for shed, lar… shed, large, wood, no…     0.0990    4.11e15 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…           1     tilt_land          tilt_world  
#>  6 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus austria high                      input_unit_input_tilt_sector tent                 market for shed, lar… shed, large, wood, no…     0.485     7.29e15 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wilhelmsburg 3150     flesch… wholesaler    76269c17-78d6-420b-99…           1     tilt_land          tilt_world  
#>  7 skarn_gallinule                    skarn_gallinule                    austria high                      all                          sheds, construction… market for shed, lar… shed, large, wood, no…     3.36      7.72e15 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wiener neud… 2355     iz nö-… wholesaler    76269c17-78d6-420b-99…           0.938 tilt_land          tilt_world  
#>  8 skarn_gallinule                    skarn_gallinule                    austria high                      input_isic_4digit            sheds, construction… market for shed, lar… shed, large, wood, no…     0.0990    9.38e15 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wiener neud… 2355     iz nö-… wholesaler    76269c17-78d6-420b-99…           1     tilt_land          tilt_world  
#>  9 skarn_gallinule                    skarn_gallinule                    austria high                      input_tilt_sector            sheds, construction… market for shed, lar… shed, large, wood, no…     0.669     7.42e15 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wiener neud… 2355     iz nö-… wholesaler    76269c17-78d6-420b-99…           1     tilt_land          tilt_world  
#> 10 skarn_gallinule                    skarn_gallinule                    austria high                      input_unit                   sheds, construction… market for shed, lar… shed, large, wood, no…     0.673     2.34e16 m2    FALSE       low                low                    shed, lar… m2         construction      construction reside… '4100'            Construction of build… wiener neud… 2355     iz nö-… wholesaler    76269c17-78d6-420b-99…           1     tilt_land          tilt_world  
#> # ℹ 680 more rows
#> # ℹ abbreviated names: ¹​matched_reference_product, ²​matching_certainty_company_average, ³​activity_uuid_product_uuid

emissions_profile_upstream_at_company_level
#> # A tibble: 1,296 × 13
#>    companies_id                       company_name                       company_city country emission_upstream_profile_share emission_upstream_profile benchmark         co2e_lower co2e_upper matching_certainty_company_average postcode address                                  main_activity
#>    <chr>                              <chr>                              <chr>        <chr>                             <dbl> <chr>                     <chr>                  <dbl>      <dbl> <chr>                              <chr>    <chr>                                    <chr>        
#>  1 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               1 high                      all                   3.36      7.72e15 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  2 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               0 medium                    all                   0.486     4.71e 7 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  3 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               0 low                       all                   0.0258    4.18e 6 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  4 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               1 high                      input_isic_4digit     0.0990    9.38e15 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  5 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               0 medium                    input_isic_4digit     0.307     3.86e 6 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  6 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               0 low                       input_isic_4digit     0.0259    1.79e 6 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  7 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               1 high                      input_tilt_sector     0.669     7.42e15 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  8 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               0 medium                    input_tilt_sector     0.306     1.52e 8 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#>  9 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               0 low                       input_tilt_sector     0.0259    2.15e 7 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#> 10 asteria_megalotomusquinquespinosus asteria_megalotomusquinquespinosus wilhelmsburg austria                               1 high                      input_unit            0.673     2.34e16 low                                3150     fleschplatz 2, top 5 | 3150 wilhelmsburg wholesaler   
#> # ℹ 1,286 more rows
```

<sup>Created on 2024-02-16 with [reprex v2.0.2](https://reprex.tidyverse.org)</sup>
