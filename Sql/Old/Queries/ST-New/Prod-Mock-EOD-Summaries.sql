/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [contract_name]
      ,[trade_date]
      ,[quantity]
      ,[market_direction_percentage]
      ,[brokerage]
      ,[actual_roi_percentage]
      ,[actual_profit]
      ,[roi_percentage]
      ,[expected_profit]
      ,[min_price]
      ,[max_price]
      ,[num_trades]
      ,[num_profit_trades]
      ,[num_loss_trades]
      ,[average_profit_pertrade]
      ,[average_loss_pertrade]
      ,[inmarket_time_in_minutes]
      ,[number_of_ticks]
      ,[algo_id]
      ,[r1]
      ,[r2]
      ,[status_update_time]
  FROM [StockTrader-QA].[dbo].[st_trading_eod_statsbook]
  
  where 
  r2 = 'Algo-Test6'
  --r2 = 'IEOD-1min-QA-New'
   --r2 = 'IEOD-1min-mock'
  and market_direction_percentage = 0.5
  --order by actual_roi_percentage desc
  and contract_name like 'CNXBAN%'
  and algo_id = 19
  --order by num_trades desc
  order by status_update_time desc
  --order by actual_profit asc