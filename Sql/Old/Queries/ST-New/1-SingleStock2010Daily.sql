
DECLARE @contracts ContractsTableType--TABLE ( contract_name varchar(100) not null)
insert into @contracts select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS() 

declare  @market_direction_percentage decimal(12, 2)
set @market_direction_percentage = 1.5
declare  @algo_id int
set @algo_id = 1
declare  @r2 varchar(100)
set @r2 = 'IEOD-1min'
declare  @r1 varchar(100)
set @r1 = '2009'
declare  @ticks_per_day int
set @ticks_per_day = 1
declare  @contract varchar(100)
set @contract = 'DLF'

select 
--eod.contract_name,
CAST(eod.trade_date AS DATE) as TRADE_DATE
      --,eod.algo_id
      ,eod.market_direction_percentage as mdp
      --,SUM(eod.algo_id) as NUM_INSTRUMENTS
      ,SUM(eod.num_trades) as NUM_TRADES
      ,SUM((eod.brokerage * .5) + eod.actual_profit) as DAY_P
      ,SUM(eod.brokerage) as DAY_B
      ,SUM(eod.actual_profit) as DAY_AP
      
      ,(SELECT SUM(eod2.max_price * .25)
		  FROM st_trading_eod_statsbook as eod2
		  where 
		  eod2.algo_id = @algo_id
		  and eod2.market_direction_percentage = eod.market_direction_percentage
		  --and eod2.r2 = @r2
		  and eod2.r1 = @r1
		  and eod2.contract_name = @contract
		  --and eod2.number_of_ticks > @ticks_per_day
		  and eod2.num_trades != 0
		  and eod2.trade_date = eod.trade_date
        ) as INVST
      
      
      ,(SELECT SUM((eod1.brokerage * .5) + eod1.actual_profit)
		  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod1
			  where 
			  eod1.algo_id = @algo_id
			  and eod1.market_direction_percentage = eod.market_direction_percentage
			  --and eod1.r2 = @r2
			  and eod1.r1 = @r1
			  --and eod1.number_of_ticks > @ticks_per_day
			  and eod1.contract_name = @contract
			  --and eod1.contract_name = 'ABAN'
			  --and eop1.status_update_time > '2012-02-26 12:00:00'
			  and eod1.trade_date <= eod.trade_date
	    ) as RUNNING_P
      
      ,MIN(eod.min_price) as MIN_PR
      ,MAX(eod.max_price) as MAX_PR
      ,(MAX(eod.max_price)-MIN(eod.min_price)) * 100 /MIN(eod.min_price) as RANGE_PR
      
	  FROM st_trading_eod_statsbook as eod
	  where 
	  eod.algo_id = @algo_id
	  --and eod.market_direction_percentage = @market_direction_percentage
	  and eod.market_direction_percentage in (0.3, 0.9, 1.3, 2.5)
	  --and eod.r2 = @r2
	  and eod.r1 = @r1
	  --and eod.number_of_ticks > @ticks_per_day
	  and eod.contract_name = @contract
	  --and eod.contract_name = 'ABAN'
	  
	  group by trade_date
	  --, contract_name
	  , market_direction_percentage
	  --, algo_id
	  
	  order by trade_date asc, market_direction_percentage asc
	  --order by DAY_P_PROFIT asc