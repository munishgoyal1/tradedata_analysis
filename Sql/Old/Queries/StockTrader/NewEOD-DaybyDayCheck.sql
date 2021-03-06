

SELECT TOP 1000 
       eod.contract_name
       ,CAST(eod.trade_date AS DATE)
      ,eod.market_direction_percentage
      --,((eod.num_trades * 0.0014 * eop.average_trade_price) + eod.actual_profit) as F_PROFIT
      ,((eod.num_trades * 0.0014 * eop.average_trade_price * .8) + eod.actual_profit) as PROFIT
      
      ,eod.actual_profit
      ,(eod.num_trades * 0.0014 * eop.average_trade_price) as BrokerageAmount
       ,eod.average_profit_pertrade
      ,eod.average_loss_pertrade
    
        ,eod.num_trades
      ,eod.num_profit_trades
      ,eod.num_loss_trades
       ,eod.actual_roi_percentage
      ,eod.roi_percentage
      ,eod.expected_profit
      ,eod.number_of_ticks
      ,eod.algo_id
    
     
      ,eod.inmarket_time_in_minutes
      
      ,eod.status_update_time
  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod, [StockTrader].[dbo].[st_trading_eop_statsbook] as eop
  where eod.algo_id =1 and eop.algo_id =1
  and eod.market_direction_percentage = 0.7 
  and eop.market_direction_percentage = 0.7 
  --and eod.contract_name = eop.contract_name
  and eod.contract_name = 'BAJAJAUTO' and eop.contract_name = 'BAJAJAUTO'
  and eop.status_update_time > '2012-02-26 12:00:00'
  order by trade_date asc
  --order by PROFIT asc, market_direction_percentage asc, algo_id asc

  
