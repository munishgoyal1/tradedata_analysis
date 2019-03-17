 Select algo_id, SUM(roi_percentage) from [StockTrader].[dbo].[st_trading_eop_statsbook]
  group by algo_id