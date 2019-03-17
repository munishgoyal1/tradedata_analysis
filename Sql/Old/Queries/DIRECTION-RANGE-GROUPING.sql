
select  roi.algo_id, roi.range1
,   COUNT(*) as numRuns  
, SUM(roi.roi_percentage) --,roi.roi_sum--, SUM(roi_percentage)
,case  
    when roi_percentage >= 0 
		then 'positive'
    else 'negative' end 
    as roi_breakup
    
from (
  select  *, case  
    when market_direction_percentage between 0 and 0.9 
		then '0.1 - 0.9'
    when market_direction_percentage between 1.1 and 1.9 
		then '1.1-1.9'
    else '2.1+' end 
    as range1
    
  --  case  
  --  when market_direction_percentage between 0 and 0.9 
		--then '0.1 - 0.9'
  --  when market_direction_percentage between 1.1 and 1.9 
		--then '1.1-1.9'
  --  else '2.1+' end 
  --  as roi1
    
  --SUM(roi_percentage) as roi_sum 
    
  from st_trading_eop_statsbook as T
  
  where algo_id != 10
  ) roi
  
  
  
  --where algo_id != 10

group by roi.range1, algo_id--, roi.roi_sum

order by algo_id, range1