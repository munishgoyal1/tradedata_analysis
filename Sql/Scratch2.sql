
update nse_eod_eq_analysis
set closepct_to_prev = ((close_price-prevclose_price)/prevclose_price) * 100



 declare @sym varchar(50)
 declare @delta decimal(4,4)
 declare @date date
 set @sym = 'ITC'
 set @delta = 1.5
 set @date = '2009-01-01'

select count(1) from nse_eod_eq_analysis 
where symbol = @sym and trddate > @date

select SUM(pct_pnl) from (
select 
case when 
lowpct_to_prev < -@delta then (close_price - (prevclose_price * (100-@delta)/100))*100/prevclose_price
when highpct_to_prev > @delta then ((prevclose_price * (100+@delta)/100)-close_price)*100/prevclose_price
end
as pct_pnl,
* from nse_eod_eq_analysis 
where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev < @delta) or (lowpct_to_prev > -@delta and highpct_to_prev > @delta))  and trddate > @date
) as p
--order by pct_pnl asc)
--trddate desc


select * from nse_eod_eq_analysis 
where symbol = @sym  and ((lowpct_to_prev < -@delta and highpct_to_prev > @delta) or (lowpct_to_prev > -@delta and highpct_to_prev < @delta))  and trddate > @date
order by trddate desc

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
