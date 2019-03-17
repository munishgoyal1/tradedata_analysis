 declare @sym varchar(50)
 declare @delta decimal(12,4)
 declare @txncost_pct decimal(12,4)
 declare @date date
 set @sym = 'SDBL'
 set @delta = 2
 set @date = '2014-05-05'
 --set @date = '2009-05-05'
 set @txncost_pct = .75

--all days
select count(1) from nse_eod_eq_analysis 
where symbol = @sym and trddate > @date

--cumulative of all single trades with stop loss hitting
select count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett_val, (SUM(pnl)-SUM(txncosts))*100/AVG(prevclose_price) as nett_pct from (
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
where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev < @delta) or (lowpct_to_prev > -@delta and highpct_to_prev > @delta))  and trddate > @date
) as p

-- all single side trades with stop loss hitting
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
* from nse_eod_eq_analysis 
where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev < @delta) or (lowpct_to_prev > -@delta and highpct_to_prev > @delta))  and trddate > @date
order by pct_pnl asc

-- cummulative of all profitable days
select count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett_val, (SUM(pnl)-SUM(txncosts))*100/AVG(prevclose_price) as nett_pct from ( 
select  2*ABS(@delta) as pct_pnl, 2*ABS(@delta)*prevclose_price/100 as pnl, @txncost_pct * prevclose_price / 100 as txncosts, * from nse_eod_eq_analysis 
where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev > @delta) )  and trddate > @date
) as p

-- all profitable days (with both side trades)
select  2*ABS(@delta) as pct_pnl, 2*ABS(@delta)*prevclose_price/100 as pnl, * from nse_eod_eq_analysis 
where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev > @delta) )  and trddate > @date
