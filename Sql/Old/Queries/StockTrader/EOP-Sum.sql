 SELECT market_direction_percentage, algo_id, SUM(actual_profit) as actual
 , SUM(expected_profit) as expected
  from st_trading_eop_statsbook
  
  where 
  --market_direction_percentage = 1.5 and 
  actual_roi_percentage != 0 
  
  group by algo_id, market_direction_percentage
  --and algo_id = 11
  
  --order by actual_roi_percentage desc