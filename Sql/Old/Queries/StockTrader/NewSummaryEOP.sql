/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [contract_name]
 ,[num_days]
     
      ,[market_direction_percentage]
      ,(brokerage+actual_profit) as F_PROFIT
      ,(brokerage+actual_profit) * 100/average_trade_price as PERC
      ,(brokerage/2 +actual_profit) as PROFIT
      
      ,[actual_profit]
      ,[brokerage]
      --,(num_trades * 0.0014 * average_trade_price) as BrokerageAmount
      ,[actual_roi_percentage]
      ,[roi_percentage]
      ,[expected_profit]
      
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
      
      
     
      ,[start_date]
      ,[end_date]
      ,[inmarket_time_in_minutes]
      
      ,[status_update_time]
  FROM [StockTrader].[dbo].[st_trading_eop_statsbook]
  where algo_id =1 and market_direction_percentage = 0.5  --and status_update_time > '2012-02-26 12:00:00'
  --order by status_update_time desc
  --group by market_direction_percentage, contract_name
  order by F_PROFIT desc, contract_name, start_date desc, market_direction_percentage asc, algo_id asc
  
  
  
  Select SUM(actual_profit) as profit, 
  SUM(num_trades) as num_trades,
  --SUM(average_trade_price),
  market_direction_percentage,
  SUM(num_trades * 0.0014 * average_trade_price) as BrokerageAmount,
  (SUM(num_trades * 0.0014 * average_trade_price) + SUM(actual_profit)) as No_brokerage_profit,
  SUM([actual_roi_percentage]) as actual_roi_perc,
  SUM([roi_percentage]) as ideal_roi_perc,
  SUM(average_trade_price) as avg_trade_price
  --((SUM(num_trades * 0.0014 * average_trade_price) + SUM(actual_profit))) as No_brokerage_profit_perc
   from [StockTrader].[dbo].[st_trading_eop_statsbook]
  where algo_id = 1 
  group by market_direction_percentage