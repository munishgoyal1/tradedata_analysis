

SELECT TOP 1000 
       eod.contract_name
       ,CAST(eod.trade_date AS DATE)
      ,eod.market_direction_percentage
      --,((eod.num_trades * 0.0014 * eop.average_trade_price) + eod.actual_profit) as F_PROFIT
      
      --,(SELECT SUM((eod1.num_trades * 0.0014 * eop1.average_trade_price * .5) + eod1.actual_profit)
      ,(SELECT SUM((eod1.brokerage * .5) + eod1.actual_profit)
      FROM [StockTrader-QA].[dbo].[st_trading_eod_statsbook] as eod1, [StockTrader-QA].[dbo].[st_trading_eop_statsbook] as eop1
  where 
  eod1.algo_id =1 and eop1.algo_id =1
  and eod1.market_direction_percentage = 0.5
  and eop1.market_direction_percentage = 0.5
  and eod1.contract_name = eop1.contract_name
  and eod1.contract_name != 'NIFTYBEES'
  and eod1.contract_name = 'ABAN'
  -- and eop1.contract_name = 'ABAN'
  --and eop1.status_update_time > '2012-02-26 12:00:00'
  and eod1.trade_date <= eod.trade_date
      ) as RUNNING_PROFIT
      
      ,((eod.num_trades * 0.0014 * eop.average_trade_price * .5) + eod.actual_profit) as PROFIT
      
      ,eod.actual_profit
      ,(eod.num_trades * 0.0014 * eop.average_trade_price) as BrokerageAmount
      ,eod.brokerage
       ,eod.average_profit_pertrade
      ,eod.average_loss_pertrade
    
        ,eod.num_trades
      ,eod.num_profit_trades
      ,eod.num_loss_trades
       ,eod.actual_roi_percentage
      ,eod.roi_percentage
      ,eod.expected_profit
      ,eod.min_price
      ,eod.max_price
      ,eod.number_of_ticks
      ,eod.algo_id
    
     
      ,eod.inmarket_time_in_minutes
      
      ,eod.status_update_time
      
      --into #t 
  FROM [StockTrader-QA].[dbo].[st_trading_eod_statsbook] as eod, [StockTrader-QA].[dbo].[st_trading_eop_statsbook] as eop
  where 
  eod.algo_id =1 and eop.algo_id =1
  and eod.market_direction_percentage = 0.5
  and eop.market_direction_percentage = 0.5
  and eod.contract_name = eop.contract_name
  and eod.contract_name != 'NIFTYBEES'
  and eod.contract_name = 'ABAN'
  -- and eop.contract_name = 'ABAN'
  --and eop.status_update_time > '2012-02-26 12:00:00'
  order by trade_date asc
  --T
  
  
--  Select trade_date (Select sum(PROFIT) from #t where trade_date <=T.trade_date)
--from #t T
  
  --order by PROFIT asc, market_direction_percentage asc, algo_id asc

  