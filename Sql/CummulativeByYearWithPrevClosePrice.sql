
 declare @delta decimal(12,4)
 declare @txncost_pct decimal(12,4)
 declare @valhurdle decimal(12,4)
 declare @pricehurdle decimal(12,4)
 declare @date date

 set @delta = 2
 set @date = '2009-05-05'
 set @txncost_pct = .75
 set @valhurdle = 10000
 set @pricehurdle = 5

 select * from (
 select symbol, year, SUM(days) days, (SUM(pnl)-SUM(txn_costs))*100/AVG(avgprice) as nett_pct, SUM(nett) as nett_val, SUM(pct_pnl) - (SUM(days) * @txncost_pct) as pct_pnl, SUM(days) * @txncost_pct as pct_txncost, AVG(avgprice) as avgprice, AVG(val) val from (
--cumulative of all single trades with stop loss hitting
select symbol, year(trddate) year,AVG(val) as val, AVG(prevclose_price) as avgprice, count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett from (
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
@txncost_pct * prevclose_price / 100 as txncosts,
* from nse_eod_eq_analysis 
where  ((lowpct_to_prev < -@delta and highpct_to_prev < @delta) or (lowpct_to_prev > -@delta and highpct_to_prev > @delta))  and trddate > @date
) as p group by symbol, year(trddate) 

union
-- cummulative of all profitable days
select symbol, year(trddate) year, AVG(val) as val, AVG(prevclose_price) as avgprice, count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett from ( 
select  2*ABS(@delta) as pct_pnl, 2*ABS(@delta)*prevclose_price/100 as pnl, @txncost_pct * prevclose_price / 100 as txncosts, * from nse_eod_eq_analysis 
where ((lowpct_to_prev < -@delta and highpct_to_prev > @delta) )  and trddate > @date
) as p group by symbol, year(trddate)

) as u  group by symbol, year
) as s where val > @valhurdle and avgprice > @pricehurdle 
and symbol = 'MAWANASUG'

order by symbol, pct_pnl desc

--select top(1) * from nse_eod_eq_analysis where symbol = 'KGL'