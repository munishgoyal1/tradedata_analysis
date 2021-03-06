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
  FROM [StockTrader].[dbo].[st_trading_eod_statsbook]
  
  where 
  
  contract_name = 'DLF_F1'
  
 and market_direction_percentage = 0.1
  
  --and (num_profit_trades > num_loss_trades)
  --where roi_percentage > 0 
  
  --group by contract_name
  
  order by roi_percentage desc
  --,contract_name asc
  
  --order by trade_date asc
  
  
  --SELECT SUM(num_trades) from st_trading_eod_statsbook
  
   --SELECT COUNT(*) from st_trading_eod_statsbook