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
      [23] "min_headcount"                      "max_headcount"                     
      [25] "ei_geography"                       "co2e_lower"                        
      [27] "co2e_upper"                         "amount_of_distinct_products"       
      [29] "emissions_profile_equal_weight"     "emissions_profile_best_case"       
      [31] "emissions_profile_worst_case"      

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
      [13] "min_headcount"                      "max_headcount"                     
      [15] "co2_avg"                           

