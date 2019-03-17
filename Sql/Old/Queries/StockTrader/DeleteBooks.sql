delete from st_trading_eod_statsbook where CAST(status_update_time as DATE) > ('03-20-2012')
delete from st_trading_eop_statsbook where r2 = 'IEOD-1sec'