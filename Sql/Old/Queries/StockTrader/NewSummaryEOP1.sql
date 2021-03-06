/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [contract_name]
 ,[num_days]
     
      ,[market_direction_percentage]
      ,[actual_roi_percentage]
      ,[roi_percentage]
      ,[number_of_ticks]
      ,[algo_id]
      ,[num_trades]
      ,[num_profit_trades]
      ,[num_loss_trades]
      ,[average_profit_pertrade]
      ,[average_loss_pertrade]
      ,[min_price]
      ,[max_price]
      ,[average_trade_price]
      
      
      ,[actual_profit]
      
      ,[expected_profit]
      ,[start_date]
      ,[end_date]
      ,[inmarket_time_in_minutes]
      
      ,[status_update_time]
  FROM [StockDB_old].[dbo].[st_trading_eop_statsbook]
  where algo_id =10 and market_direction_percentage = 0.5 -- and status_update_time > '2012-02-26 12:00:00'
  order by contract_name, market_direction_percentage asc, algo_id asc