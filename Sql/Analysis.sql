select (High-Low) as Diff, ((High-Low)/[Close]) * 100 as pct, * from YahooEODBhavcopy y
where (((High-Low)/[Close]) * 100) > 2 --between 1.5 and 3
order by pct desc




insert into YahooEODBhavcopy select * from RELIANCE