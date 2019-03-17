/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 

DISTINCT  

[last_trade_price]

	, [contract_name]
      --,[quote_time]
      
      ,[strike_price]
     
      
  FROM [StockTrader].[dbo].[st_derivatives_quote]
  
  --where instrument_type=1 or instrument_type=3
  --where instrument_type=5
  --where DATEDIFF(hour, GETDATE(), quote_time) < 3
  
  --group by last_trade_price
  
  order by 
  --contract_name desc
  last_trade_price asc
  --, quote_time desc