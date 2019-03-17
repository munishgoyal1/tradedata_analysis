DECLARE @temp decimal(12, 2)
UPDATE T
SET @temp = T.actual_profit,
T.actual_profit = T.actual_roi_percentage,
T.actual_roi_percentage = @temp
FROM st_trading_eod_statsbook T
GO