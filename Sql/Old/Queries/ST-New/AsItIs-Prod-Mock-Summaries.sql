/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [contract_name]
    
      ,[market_direction_percentage]
      ,[brokerage]
      ,[actual_roi_percentage]
      ,[actual_profit]
      ,[roi_percentage]
      ,[expected_profit]
      ,[min_price]
      ,[max_price]
      ,[average_trade_price]
      ,[num_trades]
      ,[num_profit_trades]
      ,[num_loss_trades]
      ,[average_profit_pertrade]
      ,[average_loss_pertrade]
      ,[num_days]
      ,[inmarket_time_in_minutes]
      ,[number_of_ticks]
      ,CAST(start_date as DATE) as START_DATE
      ,CAST(end_date as DATE) as END_DATE
      ,[algo_id]
      ,[r1]
      ,[r2]
      ,[status_update_time]
  FROM [StockTrader-QA].[dbo].[st_trading_eop_statsbook]
  
  where r2 = 'IEOD-1min-mock'
  
  order by status_update_time
  
  
  --update st_trading_eod_statsbook
  --set 
  ----brokerage = brokerage / 2
  ----actual_profit = actual_profit + brokerage
  
  ----actual_roi_percentage = actual_profit * 400 / max_price
  --roi_percentage = expected_profit * 400 / max_price
  
  --where r2 = 'IEOD-1min-mock'
  ----where r2 = 'IEOD-1min-mock'