select * from st_trading_eod_statsbook where contract_name = 'staban' 
and algo_id = 117 and market_direction_percentage = 0.5
order by trade_date desc
