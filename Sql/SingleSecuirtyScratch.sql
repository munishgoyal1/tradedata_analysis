 declare @sym varchar(50)
 declare @delta decimal(12,4)
 declare @txncost decimal(12,4)
 declare @date date
 set @sym = 'BALRAMCHIN'
 set @delta = 2
 set @date = '2015-05-05'
 set @txncost = .05

--all days
select count(1) from nse_eod_eq_analysis 
where symbol = @sym and trddate > @date

--cumulative of all single trades with stop loss hitting
select count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett from (
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
where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev < @delta) or (lowpct_to_prev > -@delta and highpct_to_prev > @delta))  and trddate > @date
) as p
--order by pct_pnl asc)
--trddate desc

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
select count(1) days, SUM(pct_pnl) as pct_pnl, SUM(pnl) as pnl, SUM(txncosts) as txn_costs, SUM(pnl)-SUM(txncosts) as nett from ( 
select  2*ABS(@delta) as pct_pnl, 2*ABS(@delta)*prevclose_price/100 as pnl, @txncost * prevclose_price / 100 as txncosts, * from nse_eod_eq_analysis 
where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev > @delta) )  and trddate > @date
) as p

-- all days with both side trades
select  2*ABS(@delta) as pct_pnl, 2*ABS(@delta)*prevclose_price/100 as pnl, * from nse_eod_eq_analysis 
where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev > @delta) )  and trddate > @date

---- all days with both side trades
--select * from nse_eod_eq_analysis 
--where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev > @delta) )  and trddate > @date
--order by trddate desc


---- all days with both side trades or none
--select * from nse_eod_eq_analysis 
--where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev > @delta) or (lowpct_to_prev > -@delta and highpct_to_prev < @delta))  and trddate > @date
--order by trddate desc

--select * from nse_eod_eq_analysis 
--where symbol = @sym  and prevclose_price - close_price > 0  and trddate > @date
--order by trddate desc







--select * from nse_eod_eq_analysis 
--where symbol = @sym  and lowpct_to_open < -@delta and highpct_to_open > @delta

--select * from nse_eod_eq_analysis 
--where symbol = @sym  and lowpct_to_prev > -@delta and highpct_to_prev < @delta and trddate > @date
--order by trddate desc


--select * from nse_eod_eq_analysis 
--where symbol = @sym and lowpct_to_open < -@delta and highpct_to_open > @delta

--select * from nse_eod_eq_analysis 
--where symbol = @sym  and ABS(openpct_to_prev) < 0.1


--select * from nse_eod_eq_analysis 
--where symbol = 'ITC' 
--order by trddate
----ABS(openpct_to_prev) desc
