delete1 from [StockTrader-QA].dbo.st_trading_eod_statsbook

where algo_id = 33 or algo_id = 29

delete1 from [StockTrader-QA].dbo.st_trading_eop_statsbook

where algo_id = 33 or algo_id = 29

select * from st_trading_eod_statsbook
where algo_id >= 33

order by status_update_time desc

select *  delete from st_trading_eop_statsbook
where algo_id >= 50

order by status_update_time desc


delete 
--select *  
from st_trading_eop_statsbook
where r2 = 'Algo-Hedge' --and contract_name = 'NIFTY'
and algo_id in (116, 117, 118, 119)
and market_direction_percentage = 0.1

order by status_update_time asc



select *  
from st_trading_eop_statsbook
where r2 = 'Algo-Test1'

and start_date = '2012-04-28'

--order by status_update_time asc

delete  
from st_trading_eop_statsbook
where r2 = 'Algo-Test1' and contract_name in ('NIFTY', 'MINIFT')
--and algo_id in (116, 117, 118, 119)
and market_direction_percentage not in (0.3, 0.4, 0.5, 0.6, 0.7)
and algo_id in (1)

delete  
from st_trading_eod_statsbook
where r2 = 'Algo-Test1' and ((algo_id >= 63 and algo_id <= 99) or (algo_id >= 120))

delete  
from st_trading_eop_statsbook
where r2 = 'Algo-Test1' and ((algo_id >= 63 and algo_id <= 99) or (algo_id >= 120))