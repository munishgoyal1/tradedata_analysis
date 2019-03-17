select contract_name, algo_id, SUM(roi_percentage) as roi, number_of_ticks

from st_trading_eop_statsbook

group by contract_name, algo_id, number_of_ticks

order by contract_name