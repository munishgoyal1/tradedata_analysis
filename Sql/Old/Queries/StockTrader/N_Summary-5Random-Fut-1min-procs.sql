
--CREATE TYPE ContractsTableType AS TABLE
--  (                     
--        contract_name varchar(100)
--  )
--  GO

        drop function dbo.FN_SUMMARY_RAND_5_STOCKS

		create function dbo.FN_SUMMARY_RAND_5_STOCKS
		(
		   @contracts					ContractsTableType readonly
		)

		returns table 
		as 

		return

		 Select count(*) as NumRecords
		 ,contract_name
		 --,r1
		 ,algo_id
		 ,market_direction_percentage --algo_id,
		 
		  --,SUM((num_trades * 0.0014 * average_trade_price) +actual_profit) as FULL_PROFIT
		  ,SUM((brokerage* 0.5) + actual_profit) as P_PROFIT
		  ,SUM(brokerage) as BROK
		   ,SUM(average_trade_price * 0.5)/count(*) as INVST
		  ,SUM((brokerage* 0.5) + actual_profit) * 100 * count(*)/SUM(average_trade_price * 0.5) as ROI
		  ,SUM(actual_profit) as AP
		  ,SUM(brokerage + actual_profit) as FULL_PROFIT
		  ,SUM(brokerage + actual_profit) * 100 * count(*) /SUM(average_trade_price * 0.5) as ROIFULL
		  ,SUM(num_trades) as NUM_TRADES
		  --,SUM(num_trades * 0.0014 * average_trade_price) as BROK
		  --,SUM(brokerage) as ACTUAL_BROK
		  ,SUM(number_of_ticks) as TOTAL_STOCK_TICKS
		  ,SUM(num_days) as NUM_STOCK_DAYS
		  ,MIN(CAST(start_date as DATE)) as START_DATE
		  ,MAX(CAST(end_date as DATE)) as END_DATE
		   from [StockTrader].[dbo].[st_trading_eop_statsbook] as eop
		   where 
		   --algo_id = 1 
		   --and r1 ='2006'
		   --and (number_of_ticks/num_days > 300)
		   --and (number_of_ticks/num_days > 300)
		   --and r2 not like 'Indices%'
		   --and r2 = 'IEOD-1min'
		   --and r2 like 'IEOD%'
		   --and market_direction_percentage > 0.9
		   --and 
		   --contract_name in (select * from @contracts)
		   contract_name in (SELECT * FROM @contracts)
		  group by  contract_name, algo_id, market_direction_percentage
      GO
 
 
 
    drop function dbo.FN_SUMMARY_RAND_5_STOCKS_1p5

	create function dbo.FN_SUMMARY_RAND_5_STOCKS_1p5
	(
	   @contracts					ContractsTableType readonly,
	   @market_direction_percentage	decimal(12, 2)
	)

	returns table 
	as 

	return

	 Select count(*) as NumRecords
	 ,contract_name
	 --,r1
	 ,algo_id
	 ,market_direction_percentage --algo_id,
	  --,SUM((num_trades * 0.0014 * average_trade_price) +actual_profit) as FULL_PROFIT
	  ,SUM((brokerage* 0.5) + actual_profit) as P_PROFIT
	  ,SUM(brokerage) as BROK
	   --,SUM(average_trade_price * 0.5)/count(*) as INVST
	   ,MAX(average_trade_price) * 0.5 as INVST
	  ,SUM((brokerage* 0.5) + actual_profit) * 100 /(MAX(average_trade_price) * 0.5) as ROI
	   ,SUM(actual_profit) as AP
	  ,SUM(brokerage + actual_profit) as FULL_PROFIT
	  ,SUM(brokerage + actual_profit) * 100 /(MAX(average_trade_price) * 0.5) as ROIFULL
	  ,MAX(average_trade_price) as AVG_PRICE
	  ,SUM(num_trades) as NUM_TRADES
	  --,SUM(num_trades * 0.0014 * average_trade_price) as BROK
	  --,SUM(brokerage) as ACTUAL_BROK
	  ,SUM(number_of_ticks) as TOTAL_STOCK_TICKS
	  ,SUM(num_days) as NUM_STOCK_DAYS
	  ,MIN(CAST(start_date as DATE)) as START_DATE
	  ,MAX(CAST(end_date as DATE)) as END_DATE
	   from [StockTrader].[dbo].[st_trading_eop_statsbook] as eop
	   where 
	  
	   market_direction_percentage = @market_direction_percentage
	   and contract_name in (SELECT * FROM @contracts)
	  group by  contract_name, algo_id, market_direction_percentage
	 GO


