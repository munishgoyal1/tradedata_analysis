select algo_id, SUM(roi_percentage) as roi

from st_trading_eop_statsbook

where number_of_ticks > 100000

group by algo_id
