# characterize columns

    Code
      names(unnest_product(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "emission_profile"                  
       [5] "benchmark"                          "ep_product"                        
       [7] "matched_activity_name"              "matched_reference_product"         
       [9] "co2e_lower"                         "co2e_upper"                        
      [11] "unit"                               "multi_match"                       
      [13] "matching_certainty"                 "matching_certainty_company_average"
      [15] "tilt_sector"                        "tilt_subsector"                    
      [17] "isic_4digit"                        "isic_4digit_name"                  
      [19] "company_city"                       "postcode"                          
      [21] "address"                            "main_activity"                     
      [23] "activity_uuid_product_uuid"         "profile_ranking"                   
      [25] "ei_geography"                      

---

    Code
      names(unnest_company(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "emission_profile_share"            
       [5] "emission_profile"                   "benchmark"                         
       [7] "co2e_lower"                         "co2e_upper"                        
       [9] "matching_certainty_company_average" "company_city"                      
      [11] "postcode"                           "address"                           
      [13] "main_activity"                      "profile_ranking_avg"               

# warns if the noise is too low

    The mean percent noise of the `co2*` columns is too high or too low:
    * `min`: {min}%
    * `max`: {max}%
    i Do you need to adjust the `amount` of jitter? See `?tiltIndicatorAfter_options`.

# warns if the noise is too high

    The mean percent noise of the `co2*` columns is too high or too low:
    * `min`: {min}%
    * `max`: {max}%
    i Do you need to adjust the `amount` of jitter? See `?tiltIndicatorAfter_options`.

