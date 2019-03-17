select * from st_trading_eop_statsbook
--where r2 like 'Indices%'
--where algo_id != 1
--where brokerage = 0 and num_trades > 0
where average_trade_price = 0

select * from st_trading_eop_statsbook
where r2 not like 'EOD%'


select * from st_trading_eop_statsbook
where algo_id = 0 
--and 

select COUNT(*) from st_trading_eod_statsbook
where 
max_price = 0
and r2 not like 'Indices%'

--brokerage = 0
--and num_trades != 0


--delete from st_trading_eod_statsbook where r2 like 'EOD%'