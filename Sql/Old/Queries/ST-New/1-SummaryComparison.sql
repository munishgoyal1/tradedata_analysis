


--DECLARE @contracts ContractsTableType--TABLE ( contract_name varchar(100) not null)
--insert into @contracts select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS() 

declare  @market_direction_percentage decimal(12, 2)
set @market_direction_percentage = 1.3
declare  @algo_id int
set @algo_id = 1
declare  @r2 varchar(100)
set @r2 = 'IEOD-1min'
declare  @r1 varchar(100)
set @r1 = '2009'
declare  @ticks_per_day int
set @ticks_per_day = 1
declare  @contract varchar(100)
set @contract = 'DENABANK'


    
		   Select 
		   count(*) as NumRecords
		----,contract_name
		 ,r1
		 ,algo_id
		 ,market_direction_percentage --algo_id,
		 ,SUM((brokerage* 0.5) + actual_profit) * 100 /SUM(average_trade_price * 0.5) as ROI
		  ,SUM(num_trades) as NUM_TRADES
		  ,SUM(number_of_ticks) as TOTAL_STOCK_TICKS
		  ,SUM((brokerage* 0.5) + actual_profit) as P_PROFIT
		  ,SUM(actual_profit) as AP
		  ,SUM(brokerage) as BROK
		  ,SUM(average_trade_price * 0.5) as INVST
		  ,SUM(brokerage + actual_profit) as FULL_PROFIT
		  ,SUM(brokerage + actual_profit) * 100 /SUM(average_trade_price * 0.5) as ROIFULL
		 
		  ,SUM(num_days) as NUM_STOCK_DAYS
		  ,MIN(CAST(start_date as DATE)) as START_DATE
		  ,MAX(CAST(end_date as DATE)) as END_DATE
		   --,SUM(num_trades * 0.0014 * average_trade_price) as BROK
		  --,SUM(brokerage) as ACTUAL_BROK
		   from st_trading_eop_statsbook as eop
		   where 
		   --algo_id = @algo_id
		   algo_id not in (2,3) 
		   and r1 !='2011'
		   --and (number_of_ticks/num_days > 300)
		   --and (number_of_ticks/num_days > @ticks_per_day)
		   --and r2 not like 'Indices%'
		   --and r2 = @r2
		   --and r2 like 'IEOD%'
		   --and market_direction_percentage = @market_direction_percentage
		   and market_direction_percentage in (0.1 ,0.5, 1.3, 2.5)
		   --and market_direction_percentage in (0.1, 0.3, 0.9, 1.3, 2.5)
		   --and contract_name in (select * from @contracts)--(select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS())
		   --and contract_name = @contract
		   --and contract_name in ('DLF', 'RELIANCE', 'SBIN', 'TITAN')
		  group by  
		  
		  ----contract_name, 
		  r1,
		  algo_id, 
		  market_direction_percentage--, contract_name--, algo_id
		  --order by NumRecords desc, ROI desc
		  --order by P_PROFIT desc--AP desc --FULL_PROFIT desc
		  --order by num_trades desc
		  --contract_name--, FULL_PROFIT desc
		  --order by num_trades desc
		  order by 
		  r1 asc, 
		  ----contract_name,
		  market_direction_percentage asc ,algo_id asc
		  --order by ROI desc, contract_name, r1 asc
		  --order by P_PROFIT desc
		  --order by contract_name, market_direction_percentage
		  --order by ROI asc
		  --order by contract_name, ROI desc