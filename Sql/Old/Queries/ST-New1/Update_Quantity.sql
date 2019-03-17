
update st_trading_eod_statsbook
set 
algo_id = 40
where 
  algo_id = 33
  and r2 = 'Algo-Test1'
  
  
  
  UPDATE
  
    t1
SET
    t1.actual_roi_percentage = t1.actual_profit / (t1.max_price * 0.25 * t1.quantity),
    t1.roi_percentage = t1.expected_profit / (t1.max_price * 0.25 * t1.quantity)
FROM
    st_trading_eod_statsbook as t1
--INNER JOIN
--    st_trading_eod_statsbook as t2
--ON
--    t1.contract_name = t2.contract_name
    
    --select * 
    
    --FROM
    --st_trading_eod_statsbook
    
    where --t1.actual_roi_percentage > 20 or t1.actual_roi_percentage < -20
    r2 = 'IEOD-1min-mock'
    
    
    
UPDATE
    t1
SET
    t1.quantity = t2.quantity
FROM
    st_trading_eop_statsbook as t1
INNER JOIN
    st_trading_eop_statsbook as t2
ON
    t1.contract_name = t2.contract_name
    --and t1.r2 = t2.r2
    
    where t2.quantity != 1 and t1.quantity = 1
    
    UPDATE
    t1
SET
    t1.quantity = 300000/t1.max_price
FROM
    st_trading_eod_statsbook as t1

    where t1.quantity %10 != 0 and t1.max_price != 0
    
    UPDATE
    t1
SET

    t1.actual_profit = t1.actual_profit * t1.quantity,
    t1.expected_profit = t1.expected_profit * t1.quantity,
    t1.brokerage = t1.brokerage * t1.quantity
FROM
    st_trading_eop_statsbook as t1

     where ABS(actual_roi_percentage - (actual_profit / (quantity * max_price * 0.25))) > 2
    
    
    t1.quantity %25 != 0 and t1.max_price != 0
   and DATEDIFF(d, CAST(status_update_time as DATE), GETDATE()) >= 15
   
   
   select top(1000) * from st_trading_eod_statsbook
   where quantity %25 != 0 
    and  r2 != 'IEOD-1min-mock' and r2 not like '%Algo-Test%'
    
    
    select 
   -- top(1000) *
    COUNT(*) 
    from st_trading_eop_statsbook
    where ABS(actual_roi_percentage - (actual_profit / (quantity * max_price * 0.25))) > 2
    and actual_roi_percentage - (actual_profit / (quantity * max_price * 0.25)) < 0
    and quantity > 1 and r2 != 'IEOD-1min-mock' and r2 like '%Algo-Test%'
    --order by actual_roi_percentage asc
    
declare  @contract varchar(100)
set @contract = 'MINIFT11'
declare  @algo_id int
set @algo_id = 1000

update st_trading_eop_statsbook
set 
quantity = @algo_id
where 
  r2 = 'IEOD-1min-mock'
  and contract_name = @contract
  --and quantity = 1
  
  update st_trading_eod_statsbook
set 
quantity = @algo_id
where 
  r2 = 'IEOD-1min-mock'
  --and quantity = 1
  and contract_name = @contract
  
  
  update st_trading_eod_statsbook
set 
brokerage = brokerage * quantity,
actual_profit = actual_profit * quantity,
expected_profit = expected_profit * quantity,
average_loss_pertrade = average_loss_pertrade * quantity,
average_profit_pertrade = average_profit_pertrade * quantity

where 
  r2 = 'IEOD-1min-mock'
  --and contract_name = @contract
  --and quantity = 1
  
  select distinct contract_name,  quantity 
from st_trading_eop_statsbook
where quantity > 1

order by quantity desc




UPDATE
    t1
SET
   --t1.actual_roi_percentage = (t1.actual_profit * 100)/ (t1.max_price * 0.25 * t1.quantity),
    --t1.expected_profit = t1.expected_profit + (t1.brokerage * (t1.quantity - 1))
    t1.roi_percentage = (t1.expected_profit * 100 )/ (t1.max_price * 0.25 * t1.quantity)
FROM
    st_trading_eop_statsbook as t1


--select * from st_trading_eop_statsbook as t1
where --t1.actual_roi_percentage > 20 or t1.actual_roi_percentage < -20
    r2 = 'IEOD-1min-mock'
    and 
DATEDIFF(d, CAST(status_update_time as DATE), GETDATE()) = 1--10000

and abs(t1.expected_profit) > 2 * ABS(t1.actual_profit)
and contract_name = 'STABAN'