
Select TOP 2147483647 * from
(
Select TOP 2147483647 * from
(
    select VIEW1.*, Rank() over (Partition BY (VIEW1.CONTRACT) ORDER BY VIEW1.ROI_OPTIM DESC ) AS Rank
from
    ( Select 
		 count(*) as RECORDS,
		 contract_name as contract,
		 --r1,
		 algo_id as ALGO
		 ,market_direction_percentage as MDP--algo_id,
		 ,((SUM(actual_profit) * 100) /((SUM(average_trade_price * quantity * 0.2))/count(*))) as ROI
		  ,SUM(actual_profit) as AP
		  ,SUM(expected_profit) as EP
		  ,SUM(brokerage) as BROK
		  ,((SUM(average_trade_price * quantity * 0.2))/count(*)) as INVST
		  --,SUM(brokerage + actual_profit) as FULL_P
		  ,((SUM(brokerage + actual_profit) * 100) /((SUM(average_trade_price * quantity * 0.2))/count(*))) as ROIFULL
		  ,((SUM(brokerage * 0.8 + actual_profit) * 100) /((SUM(average_trade_price * quantity * 0.2))/count(*))) as ROI_OPTIM
		  --,SUM(brokerage * 0.3 + actual_profit) as OPTIM_P
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
		  
				FROM [StockTrader-QA].[dbo].[st_trading_eop_statsbook]
			    where 
			    r2 = 'Algo-Test1'
			    --and algo_id in (40, 41, 42, 43, 44, 45, 46,47, 48)
			    --and contract_name = 'ICIBAN'
			    --and start_date between '2012-05-6' and '2012-05-7'
				group by   contract_name, algo_id ,market_direction_percentage
				
	) as VIEW1
	--order by AP desc
) as VIEW2

where VIEW2.Rank <= 3 --and VIEW2.RECORDS > 30

order by VIEW2.contract, VIEW2.Rank asc
) as VIEW3

order by VIEW3.AP desc


