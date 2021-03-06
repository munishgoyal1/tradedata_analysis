/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT TOP 1000 [contract_name]
      ,[quote_time]
      ,[instrument_type]
      ,[asset_underlying]
      ,[strike_price]
      ,[expiry_date]
      ,[last_trade_price]
      ,[asset_price]
      ,[bid_price]
      ,[offer_price]
      ,[bid_qty]
      ,[offer_qty]
      ,[traded_qty]
      ,[exchange]
  FROM [StockTrader].[dbo].[st_derivatives_quote]
  
  --where instrument_type=1 or instrument_type=3
  --where instrument_type=5
  where DATEDIFF(hour, GETDATE(), quote_time) < 3
  
  --group by instrument_type
  
  order by last_trade_price asc, quote_time desc