IF OBJECT_ID(N'dbo.sp_select_daily_running_profit','P') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_select_daily_running_profit
END
GO

CREATE PROC dbo.sp_select_daily_running_profit

	@contract_name					varchar(100),
	@r1								varchar(100),
	@r2								varchar(100),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
    @ticks_per_day					int
	
	--@start_date						datetime,
	
AS
BEGIN

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
		  eod2.algo_id = @algo_id
		  and eod2.market_direction_percentage = @market_direction_percentage
		  and eod2.r2 = @r2
		  and eod2.r1 not in (@r1)
		  and eod2.number_of_ticks > @ticks_per_day
		  and eod2.num_trades != 0
		  and eod2.trade_date = eod.trade_date
        ) as INVST
      
      
      ,(SELECT SUM((eod1.brokerage * .5) + eod1.actual_profit)
		  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod1
			  where 
			  eod1.algo_id = @algo_id
			  and eod1.market_direction_percentage = @market_direction_percentage
			  and eod1.r2 = @r2
			  and eod1.r1 not in (@r1)
			  and eod1.number_of_ticks > @ticks_per_day
			  --and eod1.contract_name != 'NIFTYBEES'
			  --and eod1.contract_name = 'ABAN'
			  --and eop1.status_update_time > '2012-02-26 12:00:00'
			  and eod1.trade_date <= eod.trade_date
	    ) as RUNNING_PROFIT
      
      
      
	  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod
	  where 
	  eod.algo_id = @algo_id
	  and eod.market_direction_percentage = @market_direction_percentage
	  and eod.r2 = @r2
	  and eod.r1 not in (@r1)
	  and eod.number_of_ticks > @ticks_per_day
	  --and eod.contract_name != 'NIFTYBEES'
	  --and eod.contract_name = 'ABAN'
	  
	  group by trade_date, market_direction_percentage, algo_id
	  
	  order by trade_date asc

END
GO


IF OBJECT_ID(N'dbo.sp_select_daily_running_profit_stockwise','P') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_select_daily_running_profit_stockwise
END
GO

CREATE PROC dbo.sp_select_daily_running_profit_stockwise

	@contract_name					varchar(100),
	@r1								varchar(100),
	@r2								varchar(100),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
    @ticks_per_day					int
	
	--@start_date						datetime,
	
AS
BEGIN

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
		  eod2.algo_id = @algo_id
		  and eod2.market_direction_percentage = @market_direction_percentage
		  and eod2.r2 = @r2
		  and eod2.r1 not in (@r1)
		  and eod2.number_of_ticks > @ticks_per_day
		  and eod2.contract_name in (@contract_name)
		  and eod2.num_trades != 0
		  and eod2.trade_date = eod.trade_date
        ) as INVST
      
      
      ,(SELECT SUM((eod1.brokerage * .5) + eod1.actual_profit)
		  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod1
			  where 
			  eod1.algo_id = @algo_id
			  and eod1.market_direction_percentage = @market_direction_percentage
			  and eod1.r2 = @r2
			  and eod1.r1 not in (@r1)
			  and eod1.number_of_ticks > @ticks_per_day
			  and eod1.contract_name in (@contract_name)
			  --and eod1.contract_name != 'NIFTYBEES'
			  --and eod1.contract_name = 'ABAN'
			  --and eop1.status_update_time > '2012-02-26 12:00:00'
			  and eod1.trade_date <= eod.trade_date
	    ) as RUNNING_PROFIT
      
      
      
	  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod
	  where 
	  eod.algo_id = @algo_id
	  and eod.market_direction_percentage = @market_direction_percentage
	  and eod.r2 = @r2
	  and eod.r1 not in (@r1)
	  and eod.number_of_ticks > @ticks_per_day
	  and eod.contract_name in (@contract_name)
	  --and eod.contract_name != 'NIFTYBEES'
	  --and eod.contract_name = 'ABAN'
	  
	  group by trade_date, market_direction_percentage, algo_id
	  
	  order by trade_date asc

END
GO


IF OBJECT_ID(N'dbo.sp_select_daily_running_profit_5rand','P') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_select_daily_running_profit_5rand
END
GO

CREATE PROC dbo.sp_select_daily_running_profit_5rand

    @contracts					ContractsTableType readonly,
	@r1								varchar(100),
	@r2								varchar(100),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
    @ticks_per_day					int
	
	--@start_date						datetime,
	
AS

BEGIN

  --DECLARE @contracts TABLE ( contract_name varchar(100) not null)
--insert into @contracts select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS() 
--insert into @contracts select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS()   
--select * from @contracts
--declare @contracts ContractsTableType
--set @contracts = (SELECT * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS())


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
		  eod2.algo_id = @algo_id
		  and eod2.market_direction_percentage = @market_direction_percentage
		  and eod2.r2 = @r2
		  and eod2.r1 not in (@r1)
		  and eod2.number_of_ticks > @ticks_per_day
		  and eod2.contract_name in (select * from @contracts)
		  and eod2.num_trades != 0
		  and eod2.trade_date = eod.trade_date
        ) as INVST
      
      
      ,(SELECT SUM((eod1.brokerage * .5) + eod1.actual_profit)
		  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod1
			  where 
			  eod1.algo_id = @algo_id
			  and eod1.market_direction_percentage = @market_direction_percentage
			  and eod1.r2 = @r2
			  and eod1.r1 not in (@r1)
			  and eod1.number_of_ticks > @ticks_per_day
			  and eod1.contract_name in (select * from @contracts)
			  --and eod1.contract_name != 'NIFTYBEES'
			  --and eod1.contract_name = 'ABAN'
			  --and eop1.status_update_time > '2012-02-26 12:00:00'
			  and eod1.trade_date <= eod.trade_date
	    ) as RUNNING_PROFIT
      
      
      
	  FROM [StockTrader].[dbo].[st_trading_eod_statsbook] as eod
	  where 
	  eod.algo_id = @algo_id
	  and eod.market_direction_percentage = @market_direction_percentage
	  and eod.r2 = @r2
	  and eod.r1 not in (@r1)
	  and eod.number_of_ticks > @ticks_per_day
	  and eod.contract_name in (select * from @contracts)
	  --and eod.contract_name != 'NIFTYBEES'
	  --and eod.contract_name = 'ABAN'
	  
	  group by trade_date, market_direction_percentage, algo_id
	  
	  order by trade_date asc

END
GO