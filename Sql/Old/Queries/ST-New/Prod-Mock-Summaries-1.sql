

declare  @market_direction_percentage decimal(12, 2)
set @market_direction_percentage = 1.5
declare  @algo_id int
set @algo_id = 1
declare  @r2 varchar(100)
set @r2 = 'IEOD-1min-mock'--'Algo-Test'--'IEOD-1min-mock'
set @r2 = 'Algo-Test6'
declare  @r1 varchar(100)
set @r1 = '2012' --'2006'
declare  @ticks_per_day int
set @ticks_per_day = 1
declare  @contract varchar(100)
set @contract = 'RELIANCE'
declare  @margin_fraction decimal(12,2)
set @margin_fraction = 0.25

    
		   Select 
		   count(*) as NumRecords
		 --,contract_name
		 --,r1
		 ,algo_id
		 ,market_direction_percentage --algo_id,
		 ,((SUM(actual_profit) * 100) /((SUM(average_trade_price * quantity * @margin_fraction))/count(*))) as ROI
		  ,SUM(actual_profit) as AP
		  ,SUM(expected_profit) as EP
		  ,SUM(brokerage) as BROK
		  ,((SUM(average_trade_price * quantity * @margin_fraction))/count(*)) as INVST
		  ,SUM(brokerage + actual_profit) as FULL_PROFIT
		  ,((SUM(brokerage + actual_profit) * 100) /((SUM(average_trade_price * quantity * @margin_fraction))/count(*))) as ROIFULL
		  --,SUM(num_days) / count(*) as NUM_STOCK_DAYS
		  ,SUM(num_trades) as NUM_TRADES
		  ,SUM(num_profit_trades) as PROFIT_TRADES
		  ,SUM(num_loss_trades) as LOSS_TRADES
		  ,SUM(average_profit_pertrade) / count(*) as AVG_P_PERTRADE
		    ,SUM(average_loss_pertrade) / count(*) as AVG_L_PERTRADE
		    ,SUM(number_of_ticks) as TOTAL_STOCK_TICKS
		  ,DATEDIFF(d, MIN(CAST(start_date as DATE)), MAX(CAST(end_date as DATE))) as NUM_STOCK_DAYS
		  ,MIN(CAST(start_date as DATE)) as START_DATE
		  ,MAX(CAST(end_date as DATE)) as END_DATE
		   --,SUM(num_trades * 0.0014 * average_trade_price) as BROK
		  --,SUM(brokerage) as ACTUAL_BROK
		   --from st_trading_eop_statsbook as eop
		    FROM [StockTrader-QA].[dbo].[st_trading_eop_statsbook]
		   where 
		   --algo_id = @algo_id 
		   --and r1 = @r1
		   --and (number_of_ticks/num_days > 300)
		   --and (number_of_ticks/num_days > @ticks_per_day)
		   --and r2 not like 'Indices%'
		   r2 = @r2
		   --and DATEDIFF(d, MIN(CAST(start_date as DATE)), MAX(CAST(end_date as DATE))) > 5
		   --and r2 like 'IEOD%'
		   --and market_direction_percentage = @market_direction_percentage
		   --and market_direction_percentage > 1
		   --and contract_name in (select * from @contracts)--(select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS())
		   --and contract_name = 'CNXBAN'
		   --and contract_name = 'MINIFT'
		   and contract_name  in ('CNXBAN', 'NIFTY', 'MINIFT')
--'CENTBOP',
--'DENABANK',
--'RELIANCE',
--'SBIN',
--'TITAN', 'SUNPHARMA', 'DLF', 'HINDUNILVR')
    --and 
--DATEDIFF(d, CAST(status_update_time as DATE), GETDATE()) = 1

		  group by  
		  
		  --contract_name 
		  --r1,
		  algo_id
		  ,market_direction_percentage

		  order by ROI desc--, contract_name
		  --order by ROIFULL desc--, contract_name
--order by market_direction_percentage desc