/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [contract_name]
      ,[trade_date]
      ,[market_direction_percentage]
      ,[roi_percentage]
      ,[expected_profit]
      ,[num_trades]
      ,[num_profit_trades]
      ,[num_loss_trades]
      ,[average_profit_pertrade]
      ,[average_loss_pertrade]
      ,[inmarket_time_in_minutes]
      ,[number_of_ticks]
      ,[algo_id]
      ,[status_update_time]
      ,[actual_roi_percentage]
      ,[actual_profit]
  FROM [StockTrader].[dbo].[st_trading_eod_statsbook]
  
  where 
  
  --contract_name = 'ABAN' and
  
  market_direction_percentage = 0.7 
  
  and algo_id = 11
  
  order by  status_update_time asc --expected_profit asc--, 