-- FOR 5 random stocks
 
    DECLARE @contracts ContractsTableType--TABLE ( contract_name varchar(100) not null)
    --insert into @contracts select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS() 
    insert into @contracts select top(50) * FROM  dbo.st_selected_contracts_book order by newid() --limit 5 
    select * from
    FN_SUMMARY_RAND_5_STOCKS_1p5 (@contracts, 1.5) as Summary5
    Select 
    COUNT(*) as NumRecords,
    --algo_id,
    --market_direction_percentage,
    SUM(P_PROFIT) as P_PROFIT, 
    SUM(BROK) as BROK,
    SUM(INVST) as INVST, 
    SUM(P_PROFIT)* 100/SUM(INVST)as ROI,
    SUM(AP) as AP,
     SUM(FULL_PROFIT) as FULL_PROFIT, 
    SUM(NUM_TRADES) as NUM_TRADES,
    MIN(START_DATE) as START,
    MAX(END_DATE) as END_DATE
    from
    FN_SUMMARY_RAND_5_STOCKS_1p5 (@contracts, 1.5)
    
    
    EXEC sp_select_daily_running_profit_5rand 
    @contracts,
	' '	,
	'IEOD-1min'	,
	1.5,
	1,
    300
    
    
    
    
--    --For all stocks
--EXEC sp_select_daily_running_profit 
--	'aa',
--	' '	,
--	'IEOD-1min'	,
--	1.5,
--	1,
--    300
    
    
    

--select 
--* 
--from VW_FUT_1MIN_DAILY_RUNNING_TOTAL
--order by VW_FUT_1MIN_DAILY_RUNNING_TOTAL.trade_date asc

---- Select max investment needed at any point of time. It is 25% of the max_price
--select 
--MAX(VW_FUT_1MIN_DAILY_RUNNING_TOTAL.INVST) 
--from VW_FUT_1MIN_DAILY_RUNNING_TOTAL