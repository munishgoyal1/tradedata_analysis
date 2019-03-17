declare  @r1 varchar(100)
set @r1 = '2012'
declare  @margin_fraction decimal(12,2)
set @margin_fraction = 0.25
declare  @optimum_brokerage_discount decimal(12,2)
set @optimum_brokerage_discount = 0.8

declare  @market_direction_percentage decimal(12, 2)
set @market_direction_percentage = .5

declare  @algo_id int
set @algo_id = 19

declare  @r2 varchar(100)
set @r2 = 'IEOD-1min'
set @r2 = 'Algo-Test5'
set @r2 = 'Algo-Test1'

declare  @contract varchar(100)
set @contract = 'CNXBAN'
--set @contract = 'NIFTY'
--set @contract = 'MINIFT'
set @contract = 'CNXBAN'

select * from(

		select 
		eod.contract_name as CONTRACT,
		CAST(eod.trade_date AS DATE) as TR_DATE
			  ,eod.algo_id as ALGO
			  ,eod.market_direction_percentage as MDP
			  ,SUM(eod.num_trades) as N_TR
			  ,SUM(eod.num_loss_trades) as L_TR
			  ,SUM(eod.num_profit_trades) as P_TR
			  ,SUM(eod.average_profit_pertrade) as AVG_P
			  ,SUM(eod.average_loss_pertrade) as AVG_L
			  ,SUM(eod.actual_profit) as DAY_AP
			  ,SUM((eod.brokerage * @optimum_brokerage_discount) + eod.actual_profit) as DAY_OP --optimum profit
			  ,SUM(eod.brokerage) as DAY_B      
			  ,(SELECT SUM((eod1.brokerage * @optimum_brokerage_discount) + eod1.actual_profit)
				  FROM [StockTrader-QA].[dbo].[st_trading_eod_statsbook] as eod1
					  where 
					  eod1.algo_id = eod.algo_id
					  and eod1.market_direction_percentage = eod.market_direction_percentage
					  and eod1.r2 = eod.r2
					  and eod1.contract_name = eod.contract_name
					  --and eod1.contract_name = 'ABAN'
					  --and eop1.status_update_time > '2012-02-26 12:00:00'
					  and eod1.trade_date <= eod.trade_date
				) as RUNNING_OPT_P
			  ,(SELECT SUM(eod1.actual_profit)
				  FROM [StockTrader-QA].[dbo].[st_trading_eod_statsbook] as eod1
					  where 
					  eod1.algo_id = eod.algo_id
					  and eod1.market_direction_percentage = eod.market_direction_percentage
					  and eod1.r2 = eod.r2
					  and eod1.contract_name = eod.contract_name
					  --and eod1.contract_name = 'ABAN'
					  --and eop1.status_update_time > '2012-02-26 12:00:00'
					  and eod1.trade_date <= eod.trade_date
				) as RUNNING_P
		      
			  ,MIN(eod.min_price) as MIN_PR
			  ,MAX(eod.max_price) as MAX_PR
			  ,(((MAX(eod.max_price)-MIN(eod.min_price)) * 100) /MIN(eod.min_price)) as RANGE_PR
		      
		FROM [StockTrader-QA].[dbo].[st_trading_eod_statsbook] as eod
			  
	    where 
			  eod.algo_id in (53) and eod.market_direction_percentage = 0.4  -- staban 152 0.6
			 --eod.algo_id in (17, 18, 19, 30, 31, 32, 40, 41, 42, 43, 44, 45, 46)
			--and eod.market_direction_percentage in (0.2, 0.3, 0.4, 0.5, 0.6)
			  --and eod.market_direction_percentage = @market_direction_percentage
			   --and eod.market_direction_percentage = 0.6
			  and eod.r2 = @r2
			  --and eod.contract_name = @contract
			  --and eod.contract_name = 'ABAN'
			  --and contract_name in ('CNXBAN', 'NIFTY', 'MINIFT')
			  and contract_name in ('nifty')--, 'RELIND')
			  
	     GROUP BY
				trade_date
			  , contract_name
			  , market_direction_percentage
			  , algo_id
			  , r2

      ) as VIEW1
      
	  ORDER BY
	   
	  TR_DATE desc,
	  RUNNING_P desc
	  --DAY_AP desc
