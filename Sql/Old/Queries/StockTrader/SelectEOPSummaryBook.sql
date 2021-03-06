/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [contract_name]
      
      ,[market_direction_percentage]
      ,[roi_percentage]
      ,[actual_profit]
      ,[expected_profit]
      ,[average_trade_price]
      ,[num_trades]
      ,[num_profit_trades]
      ,[num_loss_trades]
      ,[average_profit_pertrade]
      ,[average_loss_pertrade]
      ,[num_days]
      ,[inmarket_time_in_minutes]
      ,[number_of_ticks]
      ,[algo_id]
      ,[status_update_time]
      ,[start_date]
      ,[end_date]
  FROM [StockTrader].[dbo].[st_trading_eop_statsbook]
  
  where 
  market_direction_percentage > 0 and
  
	  market_direction_percentage = 5 and 
	  --number_of_ticks > inmarket_time_in_minutes/2 and
	  --roi_percentage >= 100
  
  algo_id = 10
  
  --order by number_of_ticks desc
  order by actual_profit asc
  --order by status_update_time desc
  
  SELECT SUM(actual_profit) FROM [StockTrader].[dbo].[st_trading_eop_statsbook] 
  
  where 
  market_direction_percentage > 0 and
  
	  market_direction_percentage = 5 and 
	  --number_of_ticks > inmarket_time_in_minutes/2 and
	  --roi_percentage >= 100
  
  algo_id = 10
  