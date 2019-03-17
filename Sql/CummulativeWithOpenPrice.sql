
 declare @delta decimal(12,4)
 declare @txncost decimal(12,4)
 declare @valhurdle decimal(12,4)
 declare @pricehurdle decimal(12,4)
 declare @date date

 set @delta = 2
 set @date = '2015-05-05'
 set @txncost = .05
 set @valhurdle = 10000000
 set @pricehurdle = 20


 select symbol, SUM(days) days, SUM(pct_pnl) - SUM(days) * @txncost as pct_pnl, SUM(days) * @txncost as pct_txncost, SUM(nett) as nettVal, AVG(avgprice) as avgprice, AVG(val) val from (
--cumulative of all single trades with stop loss hitting
select symbol, AVG(val) as val, AVG(open_price) as avgprice, count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett from (
select 
case when 
lowpct_to_open < -@delta then (close_price - (open_price * (100-@delta)/100))*100/open_price
when highpct_to_open > @delta then ((open_price * (100+@delta)/100)-close_price)*100/open_price
end
as pct_pnl,
case when 
lowpct_to_open < -@delta then (close_price - (open_price * (100-@delta)/100))
when highpct_to_open > @delta then ((open_price * (100+@delta)/100)-close_price)
end
as pnl,
@txncost * open_price / 100 as txncosts,
* from nse_eod_eq_analysis 
where  ((lowpct_to_open < -@delta and highpct_to_open < @delta) or (lowpct_to_open > -@delta and highpct_to_open > @delta))  and trddate > @date
) as p group by symbol 

union
-- cummulative of all profitable days
select symbol, AVG(val) as val, AVG(open_price) as avgprice, count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett from ( 
select  2*ABS(@delta) as pct_pnl, 2*ABS(@delta)*open_price/100 as pnl, @txncost * open_price / 100 as txncosts, * from nse_eod_eq_analysis 
where ((lowpct_to_open < -@delta and highpct_to_open > @delta) )  and trddate > @date
) as p group by symbol
) as c where val > @valhurdle and avgprice > @pricehurdle group by symbol

order by pct_pnl desc