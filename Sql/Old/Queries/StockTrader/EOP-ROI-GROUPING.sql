select market_direction_percentage, algo_id, 
SUM(roi_percentage)/COUNT(*)/4 as expected_roi, SUM(actual_roi_percentage)/COUNT(*)/4 as actual_roi, 
SUM(num_trades)/COUNT(*) as num_trades, SUM(num_profit_trades)/COUNT(*) as num_profit_trades
--,SUM(average_trade_price)/COUNT(*)
,COUNT(*) as numRuns
,SUM(average_profit_pertrade/average_trade_price)/COUNT(*) as avg_profit
,SUM(average_loss_pertrade/average_trade_price)/COUNT(*) as avg_loss
,SUM(average_profit_pertrade * num_profit_trades) as total_profit_points
,SUM(average_loss_pertrade * (num_trades-num_profit_trades)) as total_loss_points

from st_trading_eop_statsbook

 where --market_direction_percentage <2.1  and 
 algo_id != 10 
 
 and contract_name != 'SENSEX' --like '%_F1'
 
 --and number_of_ticks > 200000
 
 and DATEDIFF(day, status_update_time, GETDATE()) < 8 
  
  group by market_direction_percentage, algo_id
  
  --order by market_direction_percentage desc, algo_id asc
  
  order by expected_roi desc, algo_id asc