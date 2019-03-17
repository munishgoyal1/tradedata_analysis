
--DECLARE @contracts ContractsTableType--TABLE ( contract_name varchar(100) not null)
--insert into @contracts select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS() 

--DECLARE @algos AlgosTableType TABLE ( algo_id int not null)
--insert into @algos select * FROM (17, 18 , 19) 

declare  @market_direction_percentage decimal(12, 2)
set @market_direction_percentage = .5
declare  @algo_id int
set @algo_id = 19
declare  @r2 varchar(100)
set @r2 = 'IEOD-1min'
set @r2 = 'Algo-Test1'
set @r2 = 'Algo-Test2'
declare  @r1 varchar(100)
set @r1 = '2012'
declare  @ticks_per_day int
set @ticks_per_day = 1
declare  @margin_fraction decimal(12,2)
set @margin_fraction = 0.2
declare  @optimum_brokerage_discount decimal(12,2)
set @optimum_brokerage_discount = 0.5
declare  @contract varchar(100)
set @contract = 'CNXBAN'
--set @contract = 'NIFTY'
set @contract = 'MINIFT'

select * from(
select 
eod.contract_name as CONTR,
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
		  ----eod2.algo_id = eod.algo_id
		  --eod2.algo_id in (17, 18, 19)
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
			  --eod1.algo_id in (18, 19)
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
	  --eod.algo_id in (17, 18, 19, 30, 31, 32)
	  eod.algo_id = 32
	  and eod.market_direction_percentage in (0.5)--(0.5, 1, 1.5, 2)
	  --and eod.market_direction_percentage = @market_direction_percentage
	  and eod.r2 = @r2
	  --and eod.r1 = @r1
	  --and eod.number_of_ticks > @ticks_per_day
	  --and eod.contract_name = @contract
	  and eod.contract_name = 'STABAN'
	  --and contract_name in ('STABAN', 'CNXBAN', 'NIFTY')
	  
	  
	  group by 
	  trade_date
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
	  
	  --group by 
	  --TR_DATE
	  --, CONTR
	  --, MDP
	  --, algo_id
	  --, R2
	  
	  order by 
	  RANGE_PR asc,
	  TR_DATE, 
	  CONTR, ALGO asc
	  --DAY_AP desc