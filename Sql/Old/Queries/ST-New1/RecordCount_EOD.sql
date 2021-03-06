/****** Script for SelectTopNRows command from SSMS  ******/
select count(*) as RECORDS, V1.contract_name from (SELECT distinct [contract_name]
      ,[trade_date]
      
  FROM [StockTrader-QA].[dbo].[st_trading_eod_statsbook]
  
  where trade_date > '2012-01-01'
  
  
  --order by trade_date desc
  ) as V1
  
  group by V1.contract_name
  
  order by RECORDS desc
  
  