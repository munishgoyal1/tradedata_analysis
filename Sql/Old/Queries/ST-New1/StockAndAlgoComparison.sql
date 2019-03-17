
declare  @market_direction_percentage decimal(12, 2)
set @market_direction_percentage = 1.5
declare  @algo_id int
set @algo_id = 26
declare  @r2 varchar(100)
set @r2 = 'IEOD-1min-mock'--'Algo-Test'--'IEOD-1min-mock'
set @r2 = 'Algo-Test5'
set @r2 = 'Algo-Hedge1'
declare  @r1 varchar(100)
set @r1 = '2012' --'2006'
declare  @ticks_per_day int
set @ticks_per_day = 1
declare  @contract varchar(100)
set @contract = 'RELIANCE'
declare  @margin_fraction decimal(12,2)
set @margin_fraction = 0.2
declare  @optimum_brokerage_discount decimal(12,2)
set @optimum_brokerage_discount = 0.8

    select * from
    --TOP(15) distinct VIEW1.contract, VIEW1.* from
		   (Select 
		 count(*) as RECORDS,
		 contract_name as contract,
		 --r1,
		 algo_id as ALGO,
		 market_direction_percentage as MDP,
		 ((SUM(actual_profit) * 100) /((SUM(average_trade_price * quantity * @margin_fraction))/count(*))) as ROI
		  ,SUM(actual_profit) as AP
		  ,SUM(expected_profit) as EP
		  ,SUM(brokerage) as BROK
		  ,((SUM(average_trade_price * quantity * @margin_fraction))/count(*)) as INVST
		  ,SUM(brokerage + actual_profit) as FULL_P
		  ,((SUM(brokerage + actual_profit) * 100) /((SUM(average_trade_price * quantity * @margin_fraction))/count(*))) as ROIFULL
		  ,((SUM(brokerage * @optimum_brokerage_discount + actual_profit) * 100) /((SUM(average_trade_price * quantity * @margin_fraction))/count(*))) as ROI_OPTIM
		  --,SUM(brokerage * @optimum_brokerage_discount + actual_profit) as ROI_OPTIM
		  ,SUM(num_trades) as N_TR
		  ,SUM(num_profit_trades) as P_TR
		  ,SUM(num_loss_trades) as L_TR
		  ,(SUM(average_profit_pertrade) / count(*)) as AVG_P
		    ,(SUM(average_loss_pertrade) / count(*)) as AVG_L
		    ,(SUM(quantity) / COUNT(*)) as AVG_QTY
		    ,SUM(number_of_ticks) as NUM_TICKS
		  ,DATEDIFF(d, MIN(CAST(start_date as DATE)), MAX(CAST(end_date as DATE))) as NUM_DAYS
		  ,MIN(CAST(start_date as DATE)) as START_DATE
		  ,MAX(CAST(end_date as DATE)) as END_DATE
		   --,SUM(num_trades * 0.0014 * average_trade_price) as BROK
		  --,SUM(brokerage) as ACTUAL_BROK
		   --from st_trading_eop_statsbook as eop
		    FROM [StockTrader-QA].[dbo].[st_trading_eop_statsbook]
		   where 
		   
		   --((max_price - min_price) * 100)/min_price > 2 and
		    --and r1 = @r1
		   --and (number_of_ticks/num_days > 300)
		   --and (number_of_ticks/num_days > @ticks_per_day)
		   --and r2 not like 'Indices%'
		   --and 
		   r2 = @r2
		   --and DATEDIFF(d, MIN(CAST(start_date as DATE)), MAX(CAST(end_date as DATE))) > 5
		   --and r2 like 'IEOD%'
		   
		   --and algo_id in (10, 11, 12, 13, 14, 15, 113, 114, 115)
		   --and algo_id in (50, 51, 52, 60, 61, 62, 72)--, 17, 30, 40)
		   --and algo_id in ( 17, 18, 19, 30, 31, 32, 40, 41, 42, 43, 44, 45, 46, 50, 51, 52, 60, 61, 62, 72, 73, 82, 83, 92, 93)
		   --and algo_id in (40,41,42,43,44,45,46,47,48)
		   --and algo_id = 61
		  --and algo_id in (17, 18, 19, 30, 31, 32, 119, 150, 151, 152, 153)
		   --and market_direction_percentage = @market_direction_percentage
		   --and market_direction_percentage = 0.6
		   --and market_direction_percentage not in (0.1,0.2)
		   --and market_direction_percentage in (0.3, 0.4, 0.5)
		   --and market_direction_percentage not in (0.1, 0.2, 0.5 , 0.6, 0.7)--, 0.4, 0.5, 0.6, 0.7)
		   
		   --and contract_name in (select * from @contracts)--(select * FROM FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS())
		   --and contract_name = 'minift'
		   --and contract_name = 'staban'
		  --and contract_name = 'nifty'
		   --and contract_name in ('MINIFT','NIFTY')
		   --and contract_name in ('baauto', 'telco', 'coalin', 'iciban')
		   --and contract_name not like '%5%'
		   --and contract_name  in ('SBIN', 'BANKNIFTY','NIFTY')--, 'INFY', 'BHARTIARTL', 'AXISBANK')
		 
		   --and DATEDIFF(d, CAST(status_update_time as DATE), GETDATE()) = 0
		   --and start_date between '2012-05-15' and '2012-05-15'
		  
		  
		  group by  
		  
		  contract_name,
		  --r1,
		  algo_id,
		  market_direction_percentage
) as VIEW1
--where LOSS_TRADES != 0 and NUM_TRADES > 10

--where RECORDS > 1
 --where 
	--  ((VIEW1.contract = 'NIFTY' and ALGO != 19) or 
	--  (VIEW1.contract = 'STABAN' and ALGO != 33) or
	--  (VIEW1.contract = 'CNXBAN' and ALGO != 17)
	--  )
	--group by ALGO, MDP
	  
		  --order by (PROFIT_TRADES/LOSS_TRADES) desc--, contract_name
		  order by 
		  ROI_OPTIM desc,
		  RECORDS desc,
		  AP desc
		  
		  --
		  --contract,
		  --contract, 
		  --MDP,
		  --ALGO
		  --ROI desc--, contract_name
		  --OPTIM_P/RECORDS desc
		  --OPTIM_P desc
		  --AP asc
		  --ALGO asc,
		  --MDP asc
--order by market_direction_percentage desc
