 SELECT SUM(actual_profit), SUM(expected_profit) from st_trading_eop_statsbook
  
  where market_direction_percentage = 1.5 and actual_roi_percentage != 0 and algo_id = 11
  
  --order by actual_roi_percentage desc