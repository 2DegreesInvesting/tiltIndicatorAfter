# characterize columns

    Code
      names(unnest_product(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "ISTR_risk_category"                
       [5] "scenario"                           "year"                              
       [7] "ep_product"                         "matched_activity_name"             
       [9] "matched_reference_product"          "unit"                              
      [11] "tilt_sector"                        "multi_match"                       
      [13] "matching_certainty"                 "matching_certainty_company_average"
      [15] "input_name"                         "input_unit"                        
      [17] "input_tilt_sector"                  "input_tilt_subsector"              
      [19] "company_city"                       "postcode"                          
      [21] "address"                            "main_activity"                     
      [23] "activity_uuid_product_uuid"         "profile_ranking"                   
      [25] "extra_rowid"                        "input_isic_4digit"                 
      [27] "sector"                             "subsector"                         
      [29] "input_isic_4digit_name"             "ep_id"                             
      [31] "category"                          

---

    Code
      names(unnest_company(out))
    Output
       [1] "companies_id"                       "company_name"                      
       [3] "country"                            "ISTR_share"                        
       [5] "ISTR_risk_category"                 "scenario"                          
       [7] "year"                               "matching_certainty_company_average"
       [9] "company_city"                       "postcode"                          
      [11] "address"                            "main_activity"                     

