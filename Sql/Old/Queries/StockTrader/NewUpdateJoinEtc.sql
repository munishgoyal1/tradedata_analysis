select top(100) eop.average_trade_price, eop.contract_name, eop.market_direction_percentage from st_trading_eod_statsbook as eod
 join st_trading_eop_statsbook as eop
on
eod.contract_name = eop.contract_name 
and eod.market_direction_percentage = eop.market_direction_percentage

begin transaction
UPDATE
    st_trading_eod_statsbook
SET
    st_trading_eod_statsbook.brokerage = st_trading_eod_statsbook.num_trades * 0.0014 * st_trading_eop_statsbook.average_trade_price
FROM
    st_trading_eod_statsbook
INNER JOIN
    st_trading_eop_statsbook
ON
    st_trading_eod_statsbook.contract_name = st_trading_eop_statsbook.contract_name
    and  st_trading_eod_statsbook.market_direction_percentage = st_trading_eop_statsbook.market_direction_percentage
    --and st_trading_eod_statsbook.r1 = st_trading_eop_statsbook.r1
    and st_trading_eod_statsbook.r2 = st_trading_eop_statsbook.r2
    and st_trading_eod_statsbook.algo_id = st_trading_eop_statsbook.algo_id
    and st_trading_eod_statsbook.brokerage = 0
    and st_trading_eod_statsbook.num_trades != 0
    
    commit;
    --when exception then
    rollback;
update vw
set vw.brokerage = num_trades * 0.0014 * eop.average_trade_price
where contract_name = eop_eod_crossjoin.contract_name 
and market_direction_percentage = eop_eod_crossjoin.market_direction_percentage
from (select top(100) eop.average_trade_price, eod., eop.contract_name, eop.market_direction_percentage from st_trading_eod_statsbook as eod
 join st_trading_eop_statsbook as eop
on
eod.contract_name = eop.contract_name) as vw

select TOP(100) num_trades * 0.0014 * average_trade_price from st_trading_eod_statsbook

where brokerage = 0

select TOP(100) * from st_trading_eod_statsbook
where brokerage = 0 and num_trades != 0