 Select count(*)
 --,contract_name
 ,market_direction_percentage --algo_id,
  --,SUM((num_trades * 0.0014 * average_trade_price) +actual_profit) as FULL_PROFIT
  ,SUM(brokerage + actual_profit) as FULL_PROFIT
  ,SUM((brokerage* 0.5) + actual_profit) as P_PROFIT
  ,SUM(actual_profit) as AP
  --,SUM(num_trades * 0.0014 * average_trade_price) as BROK
  --,SUM(brokerage) as ACTUAL_BROK
  
   from [StockTrader].[dbo].[st_trading_eop_statsbook] as eop
   where algo_id = 1 
   and contract_name != 'NIFTYBEES'
  group by market_direction_percentage--, contract_name--, algo_id
  order by FULL_PROFIT desc
  
  --contract_name--, FULL_PROFIT desc