update [StockTrader].[dbo].[st_trading_eop_statsbook]

--st_trading_eod_statsbook1

--set r2 = 'Indices-IEOD-1min'
set r1 =  YEAR(end_date) 
where r1 = 'Indices'

--r1 is null
--where trade_date >= '2009-01-1' 

--and trade_date < '2008-01-1 12:00:00'

--select YEAR('2008-01-1 12:00:00') 