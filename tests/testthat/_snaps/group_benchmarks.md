# with products-benchmarks, outpts the expected groups

    Code
      group_benchmark(product_benchmarks, all)
    Output
      $all
      [1] "benchmark"        "emission_profile"
      
      $unit
      [1] "benchmark"        "emission_profile" "unit"            
      
      $tilt_sector
      [1] "benchmark"        "emission_profile" "tilt_sector"      "tilt_subsector"  
      
      $unit_tilt_sector
      [1] "benchmark"        "emission_profile" "tilt_sector"      "tilt_subsector"  
      [5] "unit"            
      
      $isic_4digit
      [1] "benchmark"        "emission_profile" "isic_4digit"     
      
      $unit_isic_4digit
      [1] "benchmark"        "emission_profile" "isic_4digit"      "unit"            
      

# with inputs-benchmarks, outpts the expected groups

    Code
      group_benchmark(input_benchmark, all)
    Output
      $all
      [1] "benchmark"                 "emission_upstream_profile"
      
      $input_unit
      [1] "benchmark"                 "emission_upstream_profile"
      [3] "input_unit"               
      
      $input_tilt_sector
      [1] "benchmark"                 "emission_upstream_profile"
      [3] "input_tilt_sector"         "input_tilt_subsector"     
      
      $input_unit_tilt_sector
      [1] "benchmark"                 "emission_upstream_profile"
      [3] "input_tilt_sector"         "input_tilt_subsector"     
      [5] "input_unit"               
      
      $input_isic_4digit
      [1] "benchmark"                 "emission_upstream_profile"
      [3] "input_isic_4digit"        
      
      $input_unit_isic_4digit
      [1] "benchmark"                 "emission_upstream_profile"
      [3] "input_isic_4digit"         "input_unit"               
      

