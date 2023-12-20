# characterize columns

    Code
      names(unnest_product(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "PCTR_risk_category"                
       [5] "benchmark"                          "ep_product"                        
       [7] "matched_activity_name"              "matched_reference_product"         
       [9] "unit"                               "multi_match"                       
      [11] "matching_certainty"                 "matching_certainty_company_average"
      [13] "tilt_sector"                        "tilt_subsector"                    
      [15] "isic_4digit"                        "isic_4digit_name"                  
      [17] "company_city"                       "postcode"                          
      [19] "address"                            "main_activity"                     
      [21] "activity_uuid_product_uuid"         "profile_ranking"                   
      [23] "extra_rowid"                        "ep_id"                             
      [25] "category"                           "geography"                         

---

    Code
      names(unnest_company(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "PCTR_share"                        
       [5] "PCTR_risk_category"                 "benchmark"                         
       [7] "matching_certainty_company_average" "company_city"                      
       [9] "postcode"                           "address"                           
      [11] "main_activity"                     

