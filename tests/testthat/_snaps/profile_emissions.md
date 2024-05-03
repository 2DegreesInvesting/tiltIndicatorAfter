# characterize columns

    Code
      names(unnest_product(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "emission_profile"                  
       [5] "benchmark"                          "ep_product"                        
       [7] "matched_activity_name"              "matched_reference_product"         
       [9] "unit"                               "multi_match"                       
      [11] "matching_certainty"                 "matching_certainty_company_average"
      [13] "tilt_sector"                        "tilt_subsector"                    
      [15] "isic_4digit"                        "isic_4digit_name"                  
      [17] "company_city"                       "postcode"                          
      [19] "address"                            "main_activity"                     
      [21] "activity_uuid_product_uuid"         "profile_ranking"                   
      [23] "ei_geography"                       "co2e_lower"                        
      [25] "co2e_upper"                        

---

    Code
      names(unnest_company(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "emission_profile_share"            
       [5] "emission_profile"                   "benchmark"                         
       [7] "matching_certainty_company_average" "company_city"                      
       [9] "postcode"                           "address"                           
      [11] "main_activity"                      "profile_ranking_avg"               
<<<<<<< HEAD
      [13] "co2_avg"                           
=======

# informs the mean noise percent

    Code
      invisible <- profile_emissions(companies, co2, europages_companies,
        ecoinvent_activities, ecoinvent_europages, isic_name)
    Message
      i Adding 48% and 99% noise to `co2e_lower` and `co2e_upper`, respectively.

# informs a useful percent noise (not 'Adding NA% ... noise') (#188)

    Code
      profile_emissions(companies, products, europages_companies = europages_companies,
        ecoinvent_activities = ecoinvent_activities, ecoinvent_europages = ecoinvent_europages,
        isic = isic_name)
    Message
      i Adding 43% and 99% noise to `co2e_lower` and `co2e_upper`, respectively.
    Output
      # A tibble: 1 x 3
        companies_id        product           company           
      * <chr>               <list>            <list>            
      1 antimonarchy_canine <tibble [7 x 24]> <tibble [24 x 11]>
>>>>>>> main

