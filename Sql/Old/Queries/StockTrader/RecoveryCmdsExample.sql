FLASHBACK TABLE [StockTrader_Indices].[dbo].[st_trading_eod_statsbook] TO BEFORE DROP


RESTORE LOG StockTrader_Indices

FROM DISK = 'D:\StockTrader\StockDB-2\StockTrader_log.ldf'

WITH RECOVERY