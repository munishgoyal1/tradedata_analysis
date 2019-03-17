SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON         -- We don't want (NULL = NULL) == TRUE
GO

SET ANSI_PADDING ON
GO

SET ANSI_NULL_DFLT_ON ON
GO

/*
*****************************************************************
* *********** TABLES ********************************************
* ***************************************************************
*/

/* Create Date: 07/04/2010
 * Purpose: Initial script to setup StockTrader database
 * Revision No: 1
*/

/*
 * Product - StockTrader
 * Product code - st
 * Table structure to hold report information
 */


/* Derivatives TradeBook */

--IF OBJECT_ID(N'dbo.st_derivatives_tradebook','U') IS NOT NULL 
--BEGIN
--	DROP TABLE dbo.st_derivatives_tradebook
--END
--GO

CREATE TABLE dbo.st_derivatives_tradebook
(
	contract_name		varchar(100) not null	,
	trade_date			datetime     default GETDATE(),
	order_ref			varchar(30)     not null,
	direction			smallint     not null,
	qty					int     not null,
	price				decimal(12, 2)     not null,
	trade_value			decimal(12, 2)	null,
	brokerage			decimal(12, 2)     not null,
	exchange			smallint	null,
	algo_id				smallint     not null,
	status_update_time	datetime	null
	
)
GO


/* Derivatives OrderBook */

--IF OBJECT_ID(N'dbo.st_derivatives_orderbook','U') IS NOT NULL 
--BEGIN
--	DROP TABLE dbo.st_derivatives_orderbook
--END
--GO

CREATE TABLE dbo.st_derivatives_orderbook
(
	contract_name		varchar(100) not null	,
	order_date			datetime     default GETDATE(),
	order_ref			varchar(30)     not null,
	direction			smallint     not null,
	qty					int     not null,
	price				decimal(12, 2)     not null,
	order_status		smallint   not null,
	qty_open			int	not null,
	qty_executed		int	not null,
	qty_cancelled		int	not null,
	qty_expired			int	not null,
	stoploss_price		decimal(12, 2)	null,
	exchange			smallint	null,
	algo_id				smallint     not null,
	status_update_time	datetime	null
)
GO



/* Derivatives OrderBook */

--IF OBJECT_ID(N'dbo.st_derivatives_quote','U') IS NOT NULL 
--BEGIN
--	DROP TABLE dbo.st_derivatives_quote
--END
--GO

CREATE TABLE dbo.st_derivatives_quote
(
	contract_name			varchar(100)     not null,
	quote_time				datetime     not null,
	instrument_type			smallint     not null,
	asset_underlying		varchar(50)     null,
	strike_price			decimal(12, 2)     null,
	expiry_date				datetime     not null,
	last_trade_price		decimal(12, 2)     not null,
	asset_price				decimal(12, 2)     null,
	bid_price				decimal(12, 2)     not null,
	offer_price				decimal(12, 2)     not null,
	bid_qty					int     not null,
	offer_qty				int     not null,
	traded_qty				int     not null,
	exchange				smallint     null
)
GO


/* EOD StatsBook */

--IF OBJECT_ID(N'dbo.st_trading_eod_statsbook','U') IS NOT NULL 
--BEGIN
--	DROP TABLE dbo.st_trading_eod_statsbook
--END
--GO

CREATE TABLE dbo.st_trading_eod_statsbook
(
	contract_name				varchar(100)		not null,
	trade_date					datetime			default GETDATE(),
	market_direction_percentage	decimal(12, 2)		not null,
	brokerage   				decimal(12, 2)		not null,
	actual_roi_percentage		decimal(12, 2)		not null,
	actual_profit				decimal(12, 2)		not null,
	roi_percentage				decimal(12, 2)		not null,
	expected_profit				decimal(12, 2)		not null,
	min_price					decimal(12, 2)		not null,
	max_price					decimal(12, 2)		not null,
	quantity					int					not null,
	num_trades					int					not null,
	num_profit_trades			int					not null,
	num_loss_trades				int					not null,
	average_profit_pertrade		decimal(12, 2)		not null,
	average_loss_pertrade		decimal(12, 2)		not null,
	inmarket_time_in_minutes	int					not null,
	number_of_ticks				int					not null,
	algo_id						smallint			not null,
	r1						    varchar(100)		 null,
	r2				            varchar(100)		 null,
	status_update_time			datetime			default GETDATE()
)
GO

/* EOP StatsBook */

--IF OBJECT_ID(N'dbo.st_trading_eop_statsbook','U') IS NOT NULL 
--BEGIN
--	DROP TABLE dbo.st_trading_eop_statsbook
--END
--GO

CREATE TABLE dbo.st_trading_eop_statsbook
(
	contract_name				varchar(100)		not null,
	start_date					datetime			default GETDATE(),
	end_date					datetime			default GETDATE(),
	market_direction_percentage	decimal(12, 2)		not null,
	brokerage   				decimal(12, 2)		not null,
	actual_roi_percentage		decimal(12, 2)		not null,
	actual_profit				decimal(12, 2)		not null,
	roi_percentage				decimal(12, 2)		not null,
	expected_profit				decimal(12, 2)		not null,
	min_price					decimal(12, 2)		not null,
	max_price					decimal(12, 2)		not null,
	quantity					int					not null,
	average_trade_price			decimal(12, 2)		not null,
	num_trades					int					not null,
	num_profit_trades			int					not null,
	num_loss_trades				int					not null,
	average_profit_pertrade		decimal(12, 2)		not null,
	average_loss_pertrade		decimal(12, 2)		not null,
	num_days					int					not null,
	inmarket_time_in_minutes	int					not null,
	number_of_ticks				int					not null,
	algo_id						smallint			not null,
	r1						    varchar(100)		 null,
	r2				            varchar(100)		 null,
	status_update_time			datetime			default GETDATE()
)
GO



CREATE TABLE dbo.st_selected_contracts_book
(
	contract_name		varchar(100) not null
)
GO

/* Indexes */

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

CREATE INDEX st_trading_eop_statsbook_Summary____00003
    ON dbo.st_trading_eop_statsbook (algo_id)
GO

CREATE INDEX st_trading_eop_statsbook_Summary____00004
    ON dbo.st_trading_eop_statsbook (r1)
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

CREATE INDEX st_trading_eod_statsbook_Summary____00003
    ON dbo.st_trading_eod_statsbook (algo_id)
GO

CREATE INDEX st_trading_eod_statsbook_Summary____00004
    ON dbo.st_trading_eod_statsbook (r1)
GO

CREATE INDEX st_trading_eod_statsbook_Summary____00005
    ON dbo.st_trading_eod_statsbook (r2)
GO

CREATE INDEX st_trading_eod_statsbook_Summary____00006
    ON dbo.st_trading_eod_statsbook (contract_name)
GO

CREATE INDEX st_trading_eod_statsbook_Summary____00007
    ON dbo.st_trading_eod_statsbook (market_direction_percentage)
GO
