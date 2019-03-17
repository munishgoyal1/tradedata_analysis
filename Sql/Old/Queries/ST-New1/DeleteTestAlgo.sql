
delete from [StockTrader-QA].[dbo].[st_trading_eod_statsbook]
where r2 = 'Algo-Test1' and contract_name = 'staban'
and algo_id in (40, 41, 42)

delete from [StockTrader-QA].[dbo].[st_trading_eop_statsbook]
where r2 = 'Algo-Test1' and contract_name = 'staban'
and algo_id in (40, 41, 42)

delete 
--select * 
from [StockTrader-QA].[dbo].[st_trading_eod_statsbook]
--where r2 = 'Algo-Test1' and contract_name = 'staban'
where algo_id in (10, 20, 21)
--and market_direction_percentage in (0.1, 0.2, 0.3, 0.4, 0.5,0.6)
and  r2 = 'Algo-Test1'


select distinct(algo_id) 
from [StockTrader-QA].[dbo].[st_trading_eop_statsbook]
where r2 = 'Algo-Test1'
order by algo_id asc