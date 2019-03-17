select 
--distinct contract_name
COUNT(*),
SUM(roi_percentage)/4/COUNT(*)--* --distinct contract_name, *

from st_trading_eop_statsbook

where number_of_ticks > 500000 and market_direction_percentage > 0.5  and market_direction_percentage < 0.9

--order by roi_percentage desc

--where contract_name = 'DEFTY' and algo_id = 9

--order by  market_direction_percentage desc
--,status_update_time asc