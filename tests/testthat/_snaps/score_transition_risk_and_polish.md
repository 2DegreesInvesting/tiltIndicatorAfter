# snapshot banchmark

    Code
      fmt_snap(unnest_product(out))
    Output
                  activity_uuid_product_uuid   benchmark        benchmark_tr_score
      1 76269c17-78d6-420b-991a-aa38c51b45b7         all         1.5C RPS_2030_all
      2 76269c17-78d6-420b-991a-aa38c51b45b7         all         1.5C RPS_2050_all
      3 76269c17-78d6-420b-991a-aa38c51b45b7         all          NZ 2050_2030_all
      4 76269c17-78d6-420b-991a-aa38c51b45b7         all          NZ 2050_2050_all
      5 76269c17-78d6-420b-991a-aa38c51b45b7 isic_4digit 1.5C RPS_2030_isic_4digit
      6 76269c17-78d6-420b-991a-aa38c51b45b7 isic_4digit 1.5C RPS_2050_isic_4digit
                              companies_id country emission_profile ep_product
      1 asteria_megalotomusquinquespinosus austria             high       tent
      2 asteria_megalotomusquinquespinosus austria             high       tent
      3 asteria_megalotomusquinquespinosus austria             high       tent
      4 asteria_megalotomusquinquespinosus austria             high       tent
      5 asteria_megalotomusquinquespinosus austria             high       tent
      6 asteria_megalotomusquinquespinosus austria             high       tent
        main_activity                                         matched_activity_name
      1    wholesaler market for shed, large, wood, non-insulated, fire-unprotected
      2    wholesaler market for shed, large, wood, non-insulated, fire-unprotected
      3    wholesaler market for shed, large, wood, non-insulated, fire-unprotected
      4    wholesaler market for shed, large, wood, non-insulated, fire-unprotected
      5    wholesaler market for shed, large, wood, non-insulated, fire-unprotected
      6    wholesaler market for shed, large, wood, non-insulated, fire-unprotected
                                 matched_reference_product profile_ranking
      1 shed, large, wood, non-insulated, fire-unprotected               1
      2 shed, large, wood, non-insulated, fire-unprotected               1
      3 shed, large, wood, non-insulated, fire-unprotected               1
      4 shed, large, wood, non-insulated, fire-unprotected               1
      5 shed, large, wood, non-insulated, fire-unprotected               1
      6 shed, large, wood, non-insulated, fire-unprotected               1
        reduction_targets scenario sector_profile  tilt_sector
      1              0.18 1.5C RPS         medium construction
      2              0.98 1.5C RPS           high construction
      3              0.40  NZ 2050           high construction
      4              0.97  NZ 2050           high construction
      5              0.18 1.5C RPS         medium construction
      6              0.98 1.5C RPS           high construction
                  tilt_subsector transition_risk_score unit year
      1 construction residential                 0.590   m2 2030
      2 construction residential                 0.990   m2 2050
      3 construction residential                 0.700   m2 2030
      4 construction residential                 0.985   m2 2050
      5 construction residential                 0.590   m2 2030
      6 construction residential                 0.990   m2 2050

---

    Code
      fmt_snap(unnest_company(out))
    Output
        benchmark benchmark_tr_score_avg                       companies_id country
      1       all      1.5C RPS_2030_all asteria_megalotomusquinquespinosus austria
      2       all      1.5C RPS_2050_all asteria_megalotomusquinquespinosus austria
      3       all       NZ 2050_2030_all asteria_megalotomusquinquespinosus austria
      4       all       NZ 2050_2050_all asteria_megalotomusquinquespinosus austria
      5       all      1.5C RPS_2030_all asteria_megalotomusquinquespinosus austria
      6       all      1.5C RPS_2050_all asteria_megalotomusquinquespinosus austria
        emission_profile emission_profile_share main_activity profile_ranking_avg
      1             high                      1    wholesaler                   1
      2             high                      1    wholesaler                   1
      3             high                      1    wholesaler                   1
      4             high                      1    wholesaler                   1
      5           medium                      0    wholesaler                   1
      6           medium                      0    wholesaler                   1
        reduction_targets_avg scenario transition_risk_score_avg year
      1                  0.18 1.5C RPS                     0.590 2030
      2                  0.98 1.5C RPS                     0.990 2050
      3                  0.40  NZ 2050                     0.700 2030
      4                  0.97  NZ 2050                     0.985 2050
      5                  0.18 1.5C RPS                     0.590 2030
      6                  0.98 1.5C RPS                     0.990 2050

