# characterize columns

    Code
      names(unnest_product(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "sector_profile_upstream"           
       [5] "reduction_targets"                  "scenario"                          
       [7] "year"                               "ep_product"                        
       [9] "matched_activity_name"              "matched_reference_product"         
      [11] "unit"                               "tilt_sector"                       
      [13] "multi_match"                        "matching_certainty"                
      [15] "matching_certainty_company_average" "input_name"                        
      [17] "input_unit"                         "input_tilt_sector"                 
      [19] "input_tilt_subsector"               "company_city"                      
      [21] "postcode"                           "address"                           
      [23] "main_activity"                      "activity_uuid_product_uuid"        
      [25] "input_isic_4digit"                  "sector_scenario"                   
      [27] "subsector_scenario"                 "ei_input_geography"                
      [29] "input_isic_4digit_name"             "ei_geography"                      

---

    Code
      names(unnest_company(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "sector_profile_upstream_share"     
       [5] "sector_profile_upstream"            "scenario"                          
       [7] "year"                               "matching_certainty_company_average"
       [9] "company_city"                       "postcode"                          
      [11] "address"                            "main_activity"                     

