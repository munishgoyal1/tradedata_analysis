/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct
	--[contract_name]
      [quote_date]
      ,[quote_time]
      --,[last_trade_price]
      --,[last_trade_price1]
      --,[last_trade_price2]
      --,[last_trade_price3]
      --,[volume]
  FROM [StockTrader].[dbo].[st_derivatives_quote_historical]
  
  where DATEDIFF(day, GETDATE(), quote_date) < 100
  
  --group by quote_date
  order by quote_date asc
  
  
  select COUNT(*) from [StockTrader].[dbo].[st_derivatives_quote_historical]