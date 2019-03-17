select SUM(expected_profit) from st_trading_eod_statsbook

 where contract_name like 'NIFTY_F1' and -- + 'INFOTECH' + '*'
  
  market_direction_percentage = 0.3
   and
  
  --where 
  trade_date > '08-10-2009' and actual_roi_percentage != 0
  
  
  
  --order by status_update_time desc
  
  
  select * from st_trading_eop_statsbook
  
  where contract_name = 'SENSEX'