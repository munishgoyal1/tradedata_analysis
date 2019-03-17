/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000
[number_of_ticks]
 ,[contract_name]
      --,[start_date]
      --,[end_date]
      ,[market_direction_percentage]
       --,[actual_profit]
      --,[actual_roi_percentage]
      ,[roi_percentage]
      ,[expected_profit]
      ,[average_trade_price]
      ,[min_price]
      ,[max_price]
      ,[num_trades]
      ,[num_profit_trades]
      ,[num_loss_trades]
      ,[average_profit_pertrade]
      ,[average_loss_pertrade]
      ,[num_days]
      ,[inmarket_time_in_minutes]
      
      ,[algo_id]
      ,[status_update_time]
     
  FROM [dbo].[st_trading_eop_statsbook]
  
  --where contract_name like '3I%' -- + 'INFOTECH' + '*'
  
  where DATEDIFF(day, GETDATE(), status_update_time) > -2
  --where market_direction_percentage = 0.1
  
  and algo_id != 10
  
  --and contract_name like'RELIANCE%'
  
  
  --group by market_direction_percentage, number_of_ticks, contract_name
  --order by status_update_time desc
  
  --where contract_name like '3II%'-- + 'INFOTECH' + '*'
  --where market_direction_percentage = 1.9 and actual_roi_percentage != 0
  
  --order by actual_roi_percentage desc
  --where actual_roi_percentage > 0
  --order by status_update_time desc
  
  
  --SELECT SUM(actual_profit) from st_trading_eop_statsbook
  
  --and market_direction_percentage = 0.3 and contract_name like '3I%' --and algo_id = 11
  --and actual_roi_percentage != 0
  
  --order by number_of_ticks desc
  
  --order by market_direction_percentage desc
  
  --order by market_direction_percentage, number_of_ticks desc
  
  order by status_update_time desc
  
  
  
  
  
  
  --delete from st_trading_eop_statsbook where contract_name = 'NAGARCONST' and algo_id = 11 and 1 = 0