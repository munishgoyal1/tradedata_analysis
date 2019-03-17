BEGIN TRAN

--delete from st_trading_eod_statsbook where r2 = 'Algo-Test433'

COMMIT TRANSACTION

--delete from st_trading_eod_statsbook
where num_trades = 0 and inmarket_time_in_minutes < 0

--delete from st_trading_eop_statsbook
--select * from st_trading_eod_statsbook
where r2 = 'Algo-Test6' and algo_id = 1111

delete from st_trading_eod_statsbook
--select * from st_trading_eod_statsbook
where algo_id >= 22
where r2 = 'Algo-Test6' and contract_name = 'FUT'

delete from st_trading_eod_statsbook
where r1 = 'Indices1'