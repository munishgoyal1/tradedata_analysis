insert  into nse_eod_eq_analysis
select symbol, series, ((high_price-low_price)/prevclose_price)* 100   as high_to_low_pct, 
((high_price-prevclose_price)/prevclose_price)* 100  as highpct_to_prev, 
((low_price-prevclose_price)/prevclose_price) * 100 as lowpct_to_prev,
((high_price-open_price)/open_price) * 100 as highpct_to_open,
((low_price-open_price)/open_price) * 100 as lowpct_to_open,
((open_price-prevclose_price)/prevclose_price) * 100 as openpct_to_prev,
open_price,
high_price,low_price,
close_price,
last_price,
prevclose_price,
qty,
val,
trddate,
numtrades,
isin
 
 from nse_eod_eq n  
 where prevclose_price > 0 and open_price > 0 and low_price > 0 and high_price > 0 and close_price > 0


	--CAST(ROUND(((high_price-low_price)/prevclose_price)* 100,6) as decimal(6,4)) 