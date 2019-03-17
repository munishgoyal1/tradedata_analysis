

--SELECT --TOP 1000 
   
   create view VW_FUT_1MIN_DAILY_RUNNING_TOTAL   as
   select
      CAST(eod.trade_date AS DATE) as TRADE_DATE
      --,eod.market_direction_percentage
      ,SUM(algo_id) as NUM_INSTRUMENTS
      ,SUM(num_trades) as NUM_TRADES
      ,SUM((eod.brokerage * .5) + eod.actual_profit) as DAY_P_PROFIT
      ,SUM(eod.brokerage) as DAY_BROKERAGE
      ,SUM(eod.actual_profit) as DAY_AP
      
      ,(SELECT SUM(eod1.max_price * .25)
		  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod1
		  where 
		  eod1.algo_id =1 
		  and eod1.market_direction_percentage = 1.5
		  and eod1.r2 not like 'Indices%'
		  and num_trades != 0
		  and eod1.trade_date = eod.trade_date
		  --group by eod1.trade_date
        ) as INVST
      
      
      ,(SELECT SUM((eod1.brokerage * .5) + eod1.actual_profit)
      FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod1
      --, [StockTrader].[dbo].[st_trading_eop_statsbook] as eop1
  where 
  eod1.algo_id =1 
  and eod1.market_direction_percentage = 1.5
  and eod1.r2 not like 'Indices%'
  --and eod1.contract_name != 'NIFTYBEES'
  --and eod1.contract_name = 'ABAN'
  --and eop1.status_update_time > '2012-02-26 12:00:00'
  and eod1.trade_date <= eod.trade_date
  --group by eod1.trade_date
      ) as RUNNING_PROFIT
      
      
      
  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod
  where 
  eod.algo_id =1 
  and eod.market_direction_percentage = 1.5
  and eod.r2 not like 'Indices%'
  --and eod.contract_name != 'NIFTYBEES'
  --and eod.contract_name = 'ABAN'
  
  group by trade_date
  
 -- order by trade_date asc
  