/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [contract_name]
      --,[trade_date]
      ,[market_direction_percentage]
      ,[actual_roi_percentage]
      ,[actual_profit]
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
      
  FROM [StockTrader].[dbo].[st_trading_eop_statsbook]
  
  where contract_name = 'ABB_F1'
   and -- + 'INFOTECH' + '*'
  
  market_direction_percentage = 0.7 
  
  --and
  
  --where 
  --trade_date > '08-10-2009' and actual_roi_percentage != 0
  
  order by status_update_time desc
  
  --order by actual_roi_percentage desc