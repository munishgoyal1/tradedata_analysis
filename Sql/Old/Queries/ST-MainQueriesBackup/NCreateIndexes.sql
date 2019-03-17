CREATE INDEX st_trading_eop_statsbook_Summary____00002
    ON dbo.st_trading_eop_statsbook (r2)
GO

CREATE INDEX st_trading_eop_statsbook_Summary____00003
    ON dbo.st_trading_eop_statsbook (algo_id)
GO


CREATE INDEX st_trading_eod_statsbook_Summary____00002
    ON dbo.st_trading_eod_statsbook (trade_date)
GO

CREATE INDEX st_trading_eod_statsbook_Summary____00003
    ON dbo.st_trading_eod_statsbook (algo_id)
GO



/* EOP StatsBook */

IF EXISTS (SELECT name FROM sysindexes WHERE name = N'dbo.st_trading_eop_statsbook_Summary____00001')
BEGIN
    DROP INDEX st_trading_eop_statsbook_Summary____00001 on dbo.st_trading_eop_statsbook
END
GO

CREATE INDEX st_trading_eop_statsbook_Summary____00001
    ON dbo.st_trading_eop_statsbook (contract_name, market_direction_percentage)
GO

CREATE INDEX st_trading_eop_statsbook_Summary____00002
    ON dbo.st_trading_eop_statsbook (r2)
GO

/* EOD StatsBook */

IF EXISTS (SELECT name FROM sysindexes WHERE name = N'dbo.st_trading_eod_statsbook_Summary____00001')
BEGIN
    DROP INDEX st_trading_eod_statsbook_Summary____00001 on dbo.st_trading_eod_statsbook
END
GO

CREATE INDEX st_trading_eod_statsbook_Summary____00001
    ON dbo.st_trading_eod_statsbook (contract_name, market_direction_percentage)
GO

CREATE INDEX st_trading_eod_statsbook_Summary____00002
    ON dbo.st_trading_eod_statsbook (trade_date)
GO