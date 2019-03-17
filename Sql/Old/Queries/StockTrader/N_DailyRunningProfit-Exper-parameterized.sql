 select
      CAST(eod.trade_date AS DATE) as TRADE_DATE
      ,eod.algo_id
      ,eod.market_direction_percentage
      ,SUM(algo_id) as NUM_INSTRUMENTS
      ,SUM(num_trades) as NUM_TRADES
      ,SUM((eod.brokerage * .5) + eod.actual_profit) as DAY_P_PROFIT
      ,SUM(eod.brokerage) as DAY_BROKERAGE
      ,SUM(eod.actual_profit) as DAY_AP
      
      ,(SELECT SUM(eod2.max_price * .25)
		  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod2
		  where 
		  eod2.algo_id = 1 
		  and eod2.market_direction_percentage = 1.5
		  and eod2.r2 = eod.r2
		  and eod2.r1 = eod.r1
		  and eod2.num_trades != 0
		  and eod2.trade_date = eod.trade_date
        ) as INVST
      
      
      ,(SELECT SUM((eod1.brokerage * .5) + eod1.actual_profit)
		  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod1
			  where 
			  eod1.algo_id =1 
			  and eod1.market_direction_percentage = 1.5
			  and eod1.r2 != 'Indices-IEOD-1min'
			  and eod1.r1 = '2010'
			  --and eod1.contract_name != 'NIFTYBEES'
			  --and eod1.contract_name = 'ABAN'
			  --and eop1.status_update_time > '2012-02-26 12:00:00'
			  and eod1.trade_date <= eod.trade_date
	    ) as RUNNING_PROFIT
      
      
      
	  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod
	  where 
	  eod.algo_id =1 
	  and eod.market_direction_percentage = 1.5
	  and eod.r2 != 'Indices-IEOD-1min'
	  and eod.r1 = '2010'
	  --and eod.contract_name != 'NIFTYBEES'
	  --and eod.contract_name = 'ABAN'
	  
	  group by trade_date, market_direction_percentage, algo_id
	  
	  order by trade_date asc
	  
	  
	  EXEC sp_select_daily_running_profit 
	  @contract_name,
	@r1	,
	@r2	,
	@market_direction_percentage,
	@algo_id,
    @ticks_per_day
    
    EXEC sp_select_daily_running_profit 
	'aa',
	' '	,
	'IEOD-1min'	,
	1.5,
	1,
    300
    
    EXEC sp_select_daily_running_profit_stockwise
	'' +   SELECT 
		 SUBSTRING( 
		 (
		  SELECT ( ', ' + contract_name)
		  FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS
		  --ORDER BY RAND() --LIMIT 5
		  FOR XML PATH('')
		 ), 3, 1000) + '',
	' '	,
	'IEOD-1min'	,
	1.5,
	1,
    300
    
    --SELECT * FROM FN_HIGH_TICKS_FUT_RECORDS_STOCKNAME ORDER BY RAND() LIMIT 1
    EXEC 
    
    select * from
    FN_SUMMARY_RAND_5_STOCKS ('AFTEKINFO', 'OFSS', 'DENABANK', 'GUJAMBCEM', 'BPCL')

    ( '' + SELECT 
		 SUBSTRING( 
		 (
		  SELECT ( ', ' + contract_name)
		  FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS
		  --ORDER BY RAND() --LIMIT 5
		  FOR XML PATH('')
		 ), 3, 100) + '' )
