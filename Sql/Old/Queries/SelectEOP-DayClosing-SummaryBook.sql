SELECT SUM(actual_profit) FROM [StockTrader].[dbo].[st_trading_eop_statsbook] 
  
  where 
  market_direction_percentage > 0 and
  
	  market_direction_percentage = 10 and 
	  --number_of_ticks > inmarket_time_in_minutes/2 and
	  --roi_percentage >= 100
  
  algo_id = 10