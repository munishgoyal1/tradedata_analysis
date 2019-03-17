select  contract_name, COUNT(*) from st_trading_eop_statsbook

where algo_id = 11

group by contract_name


--select COUNT(*) from st_trading_eop_statsbook

--where contract_name = 'APTECHT' 

--and algo_id != 10

--group by algo_id

--select * from st_trading_eop_statsbook

--where contract_name = 'HCC_F1' 

--and algo_id != 10

--group by algo_id