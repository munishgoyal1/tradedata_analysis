

--DECLARE @contracts ContractsTableType--TABLE ( contract_name varchar(100) not null)
--insert into @contracts select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS() 

declare  @market_direction_percentage decimal(12, 2)
set @market_direction_percentage = .5
declare  @algo_id int
set @algo_id = 19
declare  @r2 varchar(100)
set @r2 = 'IEOD-1min'
set @r2 = 'Algo-Test5'
set @r2 = 'Algo-Test1'
declare  @r1 varchar(100)
set @r1 = '2012'
declare  @ticks_per_day int
set @ticks_per_day = 1
declare  @margin_fraction decimal(12,2)
set @margin_fraction = 0.25
declare  @optimum_brokerage_discount decimal(12,2)
set @optimum_brokerage_discount = 0.3
declare  @contract varchar(100)
set @contract = 'CNXBAN'
--set @contract = 'NIFTY'
--set @contract = 'MINIFT'
set @contract = 'CNXBAN'

select 
--(VIEW1.RUNNING_P + .3 * VIEW1.DAY_B) as RUNNING_OP,

VIEW1.TR_DATE, SUM(VIEW1.RUNNING_P)

from(
select 
--count(distinct contract_name, trade_date, algo_id) from [StockTrader-QA].[dbo].[st_trading_eod_statsbook] as RECORDS,
eod.contract_name as CONTRACT,
CAST(eod.trade_date AS DATE) as TR_DATE
      ,eod.algo_id as ALGO
      ,eod.market_direction_percentage as MDP
      --,SUM(eod.algo_id) as NUM_INSTRUMENTS
      ,SUM(eod.num_trades) as NUM_TR
      ,SUM(eod.num_loss_trades) as LOSS_TR
      ,SUM(eod.actual_profit) as DAY_AP
      ,SUM((eod.brokerage * @optimum_brokerage_discount) + eod.actual_profit) as DAY_O_P --optimum profit
      ,SUM(eod.brokerage) as DAY_B
      
    --  ,(SELECT SUM(eod2.max_price * eod2.quantity * @margin_fraction)
		  --FROM [StockTrader-QA].[dbo].[st_trading_eod_statsbook] as eod2
		  --where 
		  --eod2.algo_id = eod.algo_id
		  --and eod2.market_direction_percentage = eod.market_direction_percentage
		  --and eod2.r2 = eod.r2
		  ----and eod2.r1 = @r1
		  --and eod2.contract_name = eod.contract_name
		  ----and eod2.number_of_ticks > @ticks_per_day
		  --and eod2.num_trades != 0
		  --and eod2.trade_date = eod.trade_date
    --    ) as INVST
      
      
      ,(SELECT SUM(/*(eod1.brokerage * @optimum_brokerage_discount) +*/ eod1.actual_profit)
		  FROM [StockTrader-QA].[dbo].[st_trading_eod_statsbook] as eod1
			  where 
			  eod1.algo_id = eod.algo_id
			  and eod1.market_direction_percentage = eod.market_direction_percentage
			  and eod1.r2 = eod.r2
			  --and eod1.r1 = @r1
			  --and eod1.number_of_ticks > @ticks_per_day
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
	  --eod.algo_id = @algo_id
	  (
	  (eod.contract_name = 'staban' and eod.algo_id = 42 and eod.market_direction_percentage = 0.6)
	  or (eod.contract_name = 'nifty' and eod.algo_id = 42 and eod.market_direction_percentage = 0.4)
	  or (eod.contract_name = 'inftec' and eod.algo_id = 41 and eod.market_direction_percentage = 0.4)
	  or (eod.contract_name = 'jaiass' and eod.algo_id = 18 and eod.market_direction_percentage = 0.2)
	  or (eod.contract_name = 'telco' and eod.algo_id = 17 and eod.market_direction_percentage = 0.3)
	  or (eod.contract_name = 'wipro' and eod.algo_id = 19 and eod.market_direction_percentage = 0.3)
	   or (eod.contract_name = 'wipro' and eod.algo_id = 19 and eod.market_direction_percentage = 0.3)
	    or (eod.contract_name = 'wipro' and eod.algo_id = 19 and eod.market_direction_percentage = 0.3)
	  )
	  --eod.algo_id in (17, 18, 19, 30, 31, 32, 40, 41, 42, 43, 44, 45, 46)
	  --and eod.market_direction_percentage in (0.2, 0.3, 0.4, 0.5, 0.6)--(0.5, 1, 1.5, 2)
	  --and eod.market_direction_percentage = @market_direction_percentage
	  and eod.r2 = @r2
	  --and eod.r1 = @r1
	  --and eod.number_of_ticks > @ticks_per_day
	  --and eod.contract_name = @contract
	  --and eod.contract_name = 'staban'
	  --and contract_name in ('CNXBAN', 'NIFTY', 'STABAN', 'INFTEC', 'SAIL', 'MCDOWE', 'JAIASS')
	  --and contract_name in ('CNXBAN')--, 'RELIND')
	  
	  group by trade_date
	  , contract_name
	  , market_direction_percentage
	  , algo_id
	  , r2
	  
	  --order by trade_date asc 
	  ----,market_direction_percentage asc
	  ----,DAY_OPT_P desc
	  --,algo_id asc
	  --order by DAY_P_PROFIT asc
	  ) as VIEW1
	  
	  --where 
	  --((VIEW1.CONTRACT = 'NIFTY' and ALGO != 19) or 
	  --(VIEW1.CONTRACT = 'STABAN' and ALGO != 17) or
	  --(VIEW1.CONTRACT = 'CNXBAN' and ALGO != 17)
	  --)
	  
	  group by TR_DATE
	  
	  order by 
	  TR_DATE desc
	  
	  --RUNNING_P desc,
	  --CONTRACT,
	  --ALGO, 
	  --DAY_AP desc
