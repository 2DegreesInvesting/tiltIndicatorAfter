# `pctr_product` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::pctr_product)
    Output
      spc_tbl_ [30 x 9] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
       $ companies_id              : chr [1:30] "id1" "id1" "id1" "id1" ...
       $ grouped_by                : chr [1:30] "all" "isic_sec" "tilt_sec" "unit" ...
       $ risk_category             : chr [1:30] "high" "medium" "low" "high" ...
       $ clustered                 : chr [1:30] "building construction" "building construction" "building construction" "building construction" ...
       $ activity_uuid_product_uuid: chr [1:30] "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" ...
       $ co2_footprint             : num [1:30] 312 312 312 312 312 ...
       $ tilt_sector               : chr [1:30] "tilt_sector A" "tilt_sector A" "tilt_sector A" "tilt_sector A" ...
       $ tilt_subsector            : chr [1:30] "tilt_subsector A" "tilt_subsector A" "tilt_subsector A" "tilt_subsector A" ...
       $ isic_4digit               : chr [1:30] "3020" "3020" "3020" "3020" ...

# `pctr_company` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::pctr_company)
    Output
      spc_tbl_ [54 x 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
       $ companies_id : chr [1:54] "id1" "id1" "id1" "id1" ...
       $ grouped_by   : chr [1:54] "all" "all" "all" "isic_sec" ...
       $ risk_category: chr [1:54] "high" "medium" "low" "high" ...
       $ value        : num [1:54] 0.5 0.5 0 0 1 0 0 0.5 0.5 1 ...

# `ictr_product` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::ictr_product)
    Output
      spc_tbl_ [330 x 10] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
       $ companies_id                    : chr [1:330] "id1" "id1" "id1" "id1" ...
       $ grouped_by                      : chr [1:330] "all" "isic_sec" "tilt_sec" "unit" ...
       $ risk_category                   : chr [1:330] "high" "medium" "medium" "high" ...
       $ clustered                       : chr [1:330] "building construction" "building construction" "building construction" "building construction" ...
       $ activity_uuid_product_uuid      : chr [1:330] "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" ...
       $ input_activity_uuid_product_uuid: chr [1:330] "7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44ccb-917e-4c8d-bb35-a1898827b659" "7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44ccb-917e-4c8d-bb35-a1898827b659" "7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44ccb-917e-4c8d-bb35-a1898827b659" "7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44ccb-917e-4c8d-bb35-a1898827b659" ...
       $ input_co2_footprint             : num [1:330] 312 312 312 312 312 ...
       $ input_tilt_sector               : chr [1:330] "tilt_sector A" "tilt_sector A" "tilt_sector A" "tilt_sector A" ...
       $ input_tilt_subsector            : chr [1:330] "tilt_subsector A" "tilt_subsector A" "tilt_subsector A" "tilt_subsector A" ...
       $ input_isic_4digit               : chr [1:330] "3020" "3020" "3020" "3020" ...

# `ictr_company` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::ictr_company)
    Output
      spc_tbl_ [54 x 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
       $ companies_id : chr [1:54] "id1" "id1" "id1" "id1" ...
       $ grouped_by   : chr [1:54] "all" "all" "all" "isic_sec" ...
       $ risk_category: chr [1:54] "high" "medium" "low" "high" ...
       $ value        : num [1:54] 0.78 0.22 0 0 1 ...

# `pstr_product` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::pstr_product)
    Output
      spc_tbl_ [19 x 10] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
       $ companies_id              : chr [1:19] "id1" "id1" "id1" "id1" ...
       $ grouped_by                : chr [1:19] "ipr_1.5c rps_2030" "weo_nz 2050_2030" "ipr_1.5c rps_2030" "weo_nz 2050_2030" ...
       $ risk_category             : chr [1:19] "medium" "high" "high" "high" ...
       $ clustered                 : chr [1:19] "building construction" "building construction" "machining" "machining" ...
       $ activity_uuid_product_uuid: chr [1:19] "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "6fcaa508-05b7-5a7b-981a-c9145f5e5dc4_a1de1103-7e58-4fe9-bd26-b86ebd3211b3" "6fcaa508-05b7-5a7b-981a-c9145f5e5dc4_a1de1103-7e58-4fe9-bd26-b86ebd3211b3" ...
       $ tilt_sector               : chr [1:19] "construction industry" "construction industry" "steel and metals" "steel and metals" ...
       $ scenario                  : chr [1:19] "1.5c rps" "nz 2050" "1.5c rps" "nz 2050" ...
       $ year                      : num [1:19] 2030 2030 2030 2030 2050 2050 2050 2050 2030 2030 ...
       $ type                      : chr [1:19] "ipr" "weo" "ipr" "weo" ...
       $ tilt_subsector            : chr [1:19] "construction buildings" "construction buildings" "steel" "steel" ...

# `istr_product` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::istr_product)
    Output
      spc_tbl_ [282 x 12] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
       $ companies_id                    : chr [1:282] "id1" "id1" "id1" "id1" ...
       $ grouped_by                      : chr [1:282] "ipr_1.5c rps_2030" "ipr_1.5c rps_2050" "weo_nz 2050_2030" "weo_nz 2050_2050" ...
       $ risk_category                   : chr [1:282] "low" "high" "medium" "high" ...
       $ clustered                       : chr [1:282] "building construction" "building construction" "building construction" "building construction" ...
       $ activity_uuid_product_uuid      : chr [1:282] "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad" ...
       $ tilt_sector                     : chr [1:282] "construction industry" "construction industry" "construction industry" "construction industry" ...
       $ scenario                        : chr [1:282] "1.5c rps" "1.5c rps" "nz 2050" "nz 2050" ...
       $ year                            : num [1:282] 2030 2050 2030 2050 2030 2050 2030 2050 2030 2050 ...
       $ type                            : chr [1:282] "ipr" "ipr" "weo" "weo" ...
       $ input_activity_uuid_product_uuid: chr [1:282] "7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44ccb-917e-4c8d-bb35-a1898827b659" "7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44ccb-917e-4c8d-bb35-a1898827b659" "7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44ccb-917e-4c8d-bb35-a1898827b659" "7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44ccb-917e-4c8d-bb35-a1898827b659" ...
       $ input_tilt_sector               : chr [1:282] "construction industry" "construction industry" "construction industry" "construction industry" ...
       $ input_tilt_subsector            : chr [1:282] "construction buildings" "construction buildings" "construction buildings" "construction buildings" ...

# `ep_companies` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::ep_companies)
    Output
      tibble [3 x 7] (S3: tbl_df/tbl/data.frame)
       $ company_name : chr [1:3] "company C" "company B" "company A"
       $ country      : chr [1:3] "austria" "germany" "germany"
       $ company_city : chr [1:3] "voitsberg" "berlin" "frankfurt"
       $ postcode     : num [1:3] 8570 13353 60316
       $ address      : chr [1:3] "ruhmannstrasse 1 | 8570 voitsberg" "sprengelstrasse 15 | 13353 berlin" "wittelsbacherallee 37 | 60316 frankfurt"
       $ main_activity: chr [1:3] "service provider" "distributor" "manufacturer/ producer"
       $ companies_id : chr [1:3] "id3" "id2" "id1"

# `ecoinvent_inputs` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::ecoinvent_inputs)
    Output
      tibble [52 x 3] (S3: tbl_df/tbl/data.frame)
       $ input_activity_uuid_product_uuid: chr [1:52] "7ac71fd7-a65b-5f2c-9289-7335f9945c11_fef44ccb-917e-4c8d-bb35-a1898827b659" "3b190359-a32e-5294-af63-983f38ce6525_759b89bd-3aa6-42ad-b767-5bb9ef5d331d" "62b803ad-e3ff-516b-947d-f08eea52c702_fbb039f7-f9cc-46d2-b631-313ddb125c1a" "372a1991-e0af-5fbf-8611-295a535373ad_9ba48284-0f03-4fec-800d-de77833b12f6" ...
       $ exchange_name                   : chr [1:52] "aluminium, wrought alloy" "electricity, medium voltage" "copper, cathode" "reinforcing steel" ...
       $ exchange_unit_name              : chr [1:52] "kg" "kWh" "kg" "kg" ...

# `matches_mapper` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::matches_mapper)
    Output
      spc_tbl_ [23,270 x 8] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
       $ ep_id                     : chr [1:23270] "0b0ae0f9eb119090c2ff57778f605898e5854f01" "0b0ae0f9eb119090c2ff57778f605898e5854f01" "0dde317dd17ad7169b1590b4f49a0ab99d4b7ee8" "0dde317dd17ad7169b1590b4f49a0ab99d4b7ee8" ...
       $ country                   : chr [1:23270] "germany" "germany" "france" "france" ...
       $ main_activity             : chr [1:23270] "service provider" "service provider" "missing" "missing" ...
       $ clustered                 : chr [1:23270] "air purifiers" "air purifiers" "aircraft engines" "aircraft engines" ...
       $ activity_uuid_product_uuid: chr [1:23270] "bcdcd9f2-a3d9-58a3-b204-c6fa665a8e49_1d8da2ef-019e-4fc8-9e15-11bd37949f61" "68a453fd-c49c-5358-9ee6-553b70ff43a8_1d8da2ef-019e-4fc8-9e15-11bd37949f61" "d7739cef-e1e3-5084-974f-f5f139975486_8eea8087-3f23-44e6-8acf-c15f2f21a528" "b2559f83-c1b9-51a9-a232-bc4d56729e0c_8eea8087-3f23-44e6-8acf-c15f2f21a528" ...
       $ multi_match               : logi [1:23270] TRUE TRUE TRUE TRUE TRUE TRUE ...
       $ completion                : chr [1:23270] "low" "low" "high" "high" ...
       $ category                  : chr [1:23270] "ep_product" "ep_product" "ep_product" "ep_product" ...

# `ecoinvent_activities` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::ecoinvent_activities)
    Output
      spc_tbl_ [100 x 5] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
       $ activity_uuid_product_uuid: chr [1:100] "dabb3812-eee9-5d2b-bc23-0f9a38e6f71e_bded6c5a-4dca-497e-bdd9-fcd343012087" "3b34f2a3-abfb-5681-ac78-60c8fada5b16_61c1d37e-ad50-4159-b379-cfe3976720bf" "3a2ab192-109a-5fa4-b9d9-7ed5421ce5c6_dfaef357-a79e-4846-aabc-848b1ab59fbb" "16e0e4f7-a44f-55d5-ae85-b2a614f42095_d5d05133-2092-451a-b9fa-c782a6ce3786" ...
       $ activity_name             : chr [1:100] "bark chips, wet, measured as dry mass to generic market for residual hardwood, wet" "market for nitrous oxide" "market for sawdust, wet, measured as dry mass" "market for sewage sludge, 70% water, WWT, WW from maize starch production" ...
       $ geography                 : chr [1:100] "CH" "GLO" "CH" "CH" ...
       $ reference_product_name    : chr [1:100] "residual hardwood, wet" "nitrous oxide" "sawdust, wet, measured as dry mass" "sewage sludge, 70% water, WWT, WW from maize starch production" ...
       $ unit                      : chr [1:100] "m3" "kg" "kg" "kg" ...

# `isic_tilt_mapper` hasn't changed

    Code
      format_minimal_snapshot(tiltIndicatorAfter::isic_tilt_mapper)
    Output
      tibble [182 x 2] (S3: tbl_df/tbl/data.frame)
       $ isic_4digit               : chr [1:182] "0111" "0112" "0113" "0114" ...
       $ isic_4digit_name_ecoinvent: chr [1:182] "Growing of cereals (except rice), leguminous crops and oil seeds" "Growing of rice" "Growing of vegetables and melons, roots and tubers" "Growing of sugar cane" ...
