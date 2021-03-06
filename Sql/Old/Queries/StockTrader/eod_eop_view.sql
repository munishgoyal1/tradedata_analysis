/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [contract_name]
      ,[market_direction_percentage]
      ,[trade_date]
      ,[algo_id]
      ,[eod_roi_perc]
      ,[num_trades]
      ,[num_profit_trades]
      ,[num_loss_trades]
  FROM [StockTrader].[dbo].[eop_eod_crossjoin]
  
  order by contract_name desc, market_direction_percentage, trade_date