 Select count(*) as NumRecords
 --,contract_name
 --,r1
 ,market_direction_percentage --algo_id,
 ,SUM(number_of_ticks)
  --,SUM((num_trades * 0.0014 * average_trade_price) +actual_profit) as FULL_PROFIT
  ,SUM(brokerage + actual_profit) as FULL_PROFIT
  ,SUM((brokerage* 0.5) + actual_profit) as P_PROFIT
  ,SUM(actual_profit) as AP
  ,SUM(brokerage) as BROK
   ,SUM(average_trade_price * 0.5) as INVST
  ,SUM((brokerage* 0.5) + actual_profit) * 100 /SUM(average_trade_price * 0.5) as ROI
  ,SUM(num_trades) as NUM_TRADES
  --,SUM(num_trades * 0.0014 * average_trade_price) as BROK
  --,SUM(brokerage) as ACTUAL_BROK
  
   from [StockDB_old].[dbo].[st_trading_eop_statsbook] as eop
   where algo_id = 1 
   --and r1='2010'
   --and (number_of_ticks/num_days > 300)
   --and market_direction_percentage > 0.9
   --and contract_name not like '%$%'--!= 'NIFTYBEES'
  group by  market_direction_percentage--, contract_name--, algo_id
  --order by P_PROFIT desc--AP desc --FULL_PROFIT desc
  --order by num_trades desc
  --contract_name--, FULL_PROFIT desc
order by num_trades desc

--Select COUNT(*) from [StockTrader].[dbo].[st_trading_eop_statsbook]