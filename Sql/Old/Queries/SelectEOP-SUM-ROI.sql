select market_direction_percentage, SUM(roi_percentage) from st_trading_eop_statsbook

 where market_direction_percentage > 0  and algo_id = 9 --and contract_name != 'SENSEX'
  
  group by market_direction_percentage
  
  order by market_direction_percentage desc
  
  --where contract_name like '3II%'-- + 'INFOTECH' + '*'
  --where market_direction_percentage = 1.9 and actual_roi_percentage != 0
  
  --order by actual_roi_percentage desc
  --where actual_roi_percentage > 0
  --order by status_update_time desc
  
  
  --SELECT SUM(actual_profit) from st_trading_eop_statsbook
  
  --where market_direction_percentage = 2.1 and actual_roi_percentage != 0
  
  --order by number_of_ticks desc
  
  --select COUNT(*) from st_trading_eop_statsbook
  
  --where market_direction_percentage = 0.1 and algo_id = 9 and contract_name like '3%'
  
  --delete from st_trading_eop_statsbook 
  
  --where contract_name like '3efrewrr%' and algo_id = 9