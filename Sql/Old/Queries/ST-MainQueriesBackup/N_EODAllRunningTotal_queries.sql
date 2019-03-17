select 
* 
from VW_FUT_1MIN_DAILY_RUNNING_TOTAL
order by VW_FUT_1MIN_DAILY_RUNNING_TOTAL.trade_date asc

-- Select max investment needed at any point of time. It is 25% of the max_price
select 
MAX(VW_FUT_1MIN_DAILY_RUNNING_TOTAL.INVST) 
from VW_FUT_1MIN_DAILY_RUNNING_TOTAL