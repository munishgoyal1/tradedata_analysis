
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

 select symbol, SUM(pct_pnl) - SUM(days) * @txncost as pct_pnl, SUM(nett) as nett, AVG(val) val, AVG(avgprice) as avgprice from (
--cumulative of all single trades with stop loss hitting
select symbol, AVG(val) as val, AVG(prevclose_price) as avgprice, count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett from (
select 
case when 
lowpct_to_prev < -@delta then (close_price - (prevclose_price * (100-@delta)/100))*100/prevclose_price
when highpct_to_prev > @delta then ((prevclose_price * (100+@delta)/100)-close_price)*100/prevclose_price
end
as pct_pnl,
case when 
lowpct_to_prev < -@delta then (close_price - (prevclose_price * (100-@delta)/100))
when highpct_to_prev > @delta then ((prevclose_price * (100+@delta)/100)-close_price)
end
as pnl,
@txncost * prevclose_price / 100 as txncosts,
* from nse_eod_eq_analysis 
where  ((lowpct_to_prev < -@delta and highpct_to_prev < @delta) or (lowpct_to_prev > -@delta and highpct_to_prev > @delta))  and trddate > @date
) as p group by symbol 

union
-- cummulative of all profitable days
select symbol, AVG(val) as val, AVG(prevclose_price) as avgprice, count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett from ( 
select  2*ABS(@delta) as pct_pnl, 2*ABS(@delta)*prevclose_price/100 as pnl, @txncost * prevclose_price / 100 as txncosts, * from nse_eod_eq_analysis 
where ((lowpct_to_prev < -@delta and highpct_to_prev > @delta) )  and trddate > @date
) as p group by symbol
) as c where val > @valhurdle and avgprice > @pricehurdle group by symbol

order by pct_pnl desc

--select top(1) * from nse_eod_eq_analysis where symbol = 'KGL'