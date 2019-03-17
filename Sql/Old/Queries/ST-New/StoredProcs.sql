BEGIN TRAN

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
* *********** STORED PROCEDURES**********************************
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

 -- UPDATE Table1 SET (...) WHERE Column1='SomeValue'
--IF @@ROWCOUNT=0
--    INSERT INTO Table1 VALUES (...)


/* Update into Derivatives TradeBook */

IF OBJECT_ID(N'dbo.sp_update_st_derivatives_tradebook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_update_st_derivatives_tradebook
END
GO

CREATE PROC dbo.sp_update_st_derivatives_tradebook

	@contractName		varchar(100),
	@tradeDate			datetime,
	@orderRef			varchar(30)     ,
	@direction			smallint     ,
	@qty				int     ,
	@price				decimal(12, 2)     ,
	@tradeValue			decimal(12, 2)	,
	@brokerage			decimal(12, 2)     ,
	@exchange			smallint	,
	@algoId				smallint     ,
	@statusUpdateAt		datetime	,
	@updateStatus		BIT OUTPUT
	
AS
BEGIN

	UPDATE st_derivatives_tradebook set brokerage=@brokerage, status_update_time=@statusUpdateAt where order_ref=@orderRef

	IF @@ERROR = 0 
		BEGIN
			SET @updateStatus = 1
		END 
END
GO


/* Insert into Derivatives TradeBook */

IF OBJECT_ID(N'dbo.sp_insert_st_derivatives_tradebook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_insert_st_derivatives_tradebook
END
GO

CREATE PROC dbo.sp_insert_st_derivatives_tradebook

	@contractName		varchar(100),
	@tradeDate			datetime,
	@orderRef			varchar(30)     ,
	@direction			smallint     ,
	@qty				int     ,
	@price				decimal(12, 2)     ,
	@tradeValue			decimal(12, 2)	,
	@brokerage			decimal(12, 2)     ,
	@exchange			smallint	,
	@algoId				smallint     ,
	@statusUpdateAt		datetime	,
	@insertStatus				BIT OUTPUT
	
AS
BEGIN
		INSERT INTO st_derivatives_tradebook
		(
			contract_name,
			trade_date,
			order_ref,
			direction,
			qty,
			price,
			trade_value,
			brokerage,
			exchange,
			algo_id,
			status_update_time
		)
		VALUES
		(
			@contractName,
			@tradeDate,
			@orderRef,
			@direction,
			@qty,
			@price,
			@tradeValue,
			@brokerage,
			@exchange,
			@algoId,
			@statusUpdateAt
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO

/* Upsert into Derivatives TradeBook */

IF OBJECT_ID(N'dbo.sp_upsert_st_derivatives_tradebook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_upsert_st_derivatives_tradebook
END
GO

CREATE PROC dbo.sp_upsert_st_derivatives_tradebook

	@contractName		varchar(100),
	@tradeDate			datetime,
	@orderRef			varchar(30)     ,
	@direction			smallint     ,
	@qty				int     ,
	@price				decimal(12, 2)     ,
	@tradeValue			decimal(12, 2)	,
	@brokerage			decimal(12, 2)     ,
	@exchange			smallint	,
	@algoId				smallint     ,
	@statusUpdateAt		datetime	,

	@upsertStatus	BIT OUTPUT
	
AS
BEGIN

	IF EXISTS (SELECT * FROM st_derivatives_tradebook WHERE order_ref=@orderRef)
	--BEGIN
	EXEC sp_update_st_derivatives_tradebook @contractName, @tradeDate, @orderRef, @direction, @qty, @price, 
	@tradeValue, @brokerage, @exchange, @algoId, @statusUpdateAt, @upsertStatus;

	ELSE
	--IF @@ROWCOUNT=0
	EXEC sp_insert_st_derivatives_tradebook @contractName, @tradeDate, @orderRef, @direction, @qty, @price, 
	@tradeValue, @brokerage, @exchange, @algoId, @statusUpdateAt, @upsertStatus;

END
GO

-- UPDATE Table1 SET (...) WHERE Column1='SomeValue'
--IF @@ROWCOUNT=0
--    INSERT INTO Table1 VALUES (...)


/* Update into Derivatives OrderBook */

IF OBJECT_ID(N'dbo.sp_update_st_derivatives_orderbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_update_st_derivatives_orderbook
END
GO

CREATE PROC dbo.sp_update_st_derivatives_orderbook

	@contractName		varchar(100),
	@orderDate			datetime,
	@orderRef			varchar(30)     ,
	@direction			smallint     ,
	@qty				int     ,
	@price				decimal(12, 2)     ,
	@exchange			smallint	,
	@algoId				smallint     ,
	@statusUpdateAt		datetime	,

	@stoplossPrice		decimal(12, 2)     ,
	@orderStatus		smallint     ,
	@qtyOpen			int	,
	@qtyExecuted		int	,
	@qtyCancelled		int	,
	@qtyExpired			int	,

	@upsertStatus		BIT OUTPUT
	
AS
BEGIN

	UPDATE st_derivatives_orderbook 
	SET 
	qty=@qty, 
	price=@price,
	stoploss_price=@stoplossPrice,
	order_status=@orderStatus,
	qty_open=@qtyOpen, 
	qty_executed=@qtyExecuted, 
	qty_cancelled=@qtyCancelled, 
	qty_expired=@qtyExpired, 

	status_update_time=@statusUpdateAt 
	
	WHERE order_ref=@orderRef

	IF @@ERROR = 0 
		BEGIN
			SET @upsertStatus = 1
		END 

END
GO

/* Insert into Derivatives OrderBook */

IF OBJECT_ID(N'dbo.sp_insert_st_derivatives_orderbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_insert_st_derivatives_orderbook
END
GO

CREATE PROC dbo.sp_insert_st_derivatives_orderbook

	@contractName		varchar(100),
	@orderDate			datetime,
	@orderRef			varchar(30)     ,
	@direction			smallint     ,
	@qty				int     ,
	@price				decimal(12, 2)     ,
	@exchange			smallint	,
	@algoId				smallint     ,
	@statusUpdateAt		datetime	,

	@stoplossPrice		decimal(12, 2)     ,
	@orderStatus		smallint     ,
	@qtyOpen			int	,
	@qtyExecuted		int	,
	@qtyCancelled		int	,
	@qtyExpired			int	,
	
	@insertStatus		BIT OUTPUT
	
AS
BEGIN
		INSERT INTO st_derivatives_orderbook
		(
			contract_name,
			order_date,
			order_ref,
			direction,
			qty,
			price,
			exchange,
			algo_id,
			status_update_time,

			stoploss_price,
			order_status,
			qty_open,
			qty_executed,
			qty_cancelled,
			qty_expired
		)
		VALUES
		(
			@contractName,
			@orderDate,
			@orderRef,
			@direction,
			@qty,
			@price,
			@exchange,
			@algoId,
			@statusUpdateAt,

			@stoplossPrice,
			@orderStatus,
			@qtyOpen,
			@qtyExecuted,
			@qtyCancelled,
			@qtyExpired
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO


/* Upsert into Derivatives OrderBook */

IF OBJECT_ID(N'dbo.sp_upsert_st_derivatives_orderbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_upsert_st_derivatives_orderbook
END
GO

CREATE PROC dbo.sp_upsert_st_derivatives_orderbook

	@contractName		varchar(100),
	@orderDate			datetime,
	@orderRef			varchar(30)     ,
	@direction			smallint     ,
	@qty				int     ,
	@price				decimal(12, 2)     ,
	@exchange			smallint	,
	@algoId				smallint     ,
	@statusUpdateAt		datetime	,

	@stoplossPrice		decimal(12, 2)     ,
	@orderStatus		smallint     ,
	@qtyOpen			int	,
	@qtyExecuted		int	,
	@qtyCancelled		int	,
	@qtyExpired			int	,

	@upsertStatus	BIT OUTPUT
	
AS
BEGIN

	IF EXISTS (SELECT * FROM st_derivatives_orderbook WHERE order_ref=@orderRef)
	--BEGIN
	EXEC sp_update_st_derivatives_orderbook @contractName, @orderDate, @orderRef, @direction, @qty, @price, @exchange, 
	@algoId, @statusUpdateAt, @stoplossPrice, @orderStatus, @qtyOpen, @qtyExecuted, @qtyCancelled, @qtyExpired, @upsertStatus;

	ELSE
	--IF @@ROWCOUNT=0
	EXEC sp_insert_st_derivatives_orderbook @contractName, @orderDate, @orderRef, @direction, @qty, @price, @exchange, 
	@algoId, @statusUpdateAt, @stoplossPrice, @orderStatus, @qtyOpen, @qtyExecuted, @qtyCancelled, @qtyExpired, @upsertStatus;

END
GO

/* Insert into Derivatives Quotes */

IF OBJECT_ID(N'dbo.sp_insert_st_derivatives_quote','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_insert_st_derivatives_quote
END
GO

CREATE PROC dbo.sp_insert_st_derivatives_quote

	@contractName			varchar(100),
	@quoteTime				datetime,
	@instrumentType			smallint     ,
	@assetUnderlying		varchar(50)     ,
	@strikePrice			decimal(12, 2)     ,
	@expiryDate				datetime,
	@lastTradePrice			decimal(12, 2)     ,
	@assetPrice				decimal(12, 2)     ,
	@bidPrice				decimal(12, 2)     ,
	@offerPrice				decimal(12, 2)     ,
	@bidQty					int     ,
	@offerQty				int     ,
	@tradedQty				int     ,
	@exchange				smallint, 
	@insertStatus		BIT OUTPUT
	
AS
BEGIN
		INSERT INTO st_derivatives_quote
		(
			contract_name,
			quote_time,
			instrument_type,
			asset_underlying,
			strike_price,
			expiry_date,
			last_trade_price,
			asset_price,
			bid_price,
			offer_price,
			bid_qty,
			offer_qty,
			traded_qty,
			exchange
		)
		VALUES
		(
			@contractName,
			@quoteTime,
			@instrumentType,
			@assetUnderlying,
			@strikePrice,
			@expiryDate,
			@lastTradePrice,
			@assetPrice,
			@bidPrice,
			@offerPrice,
			@bidQty,
			@offerQty,
			@tradedQty,
			@exchange 
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO

/* Delete Derivatives Quote */

IF OBJECT_ID(N'dbo.sp_delete_st_derivatives_quote','P') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_delete_st_derivatives_quote
END
GO

CREATE PROC dbo.sp_delete_st_derivatives_quote
AS		
BEGIN
	DELETE FROM st_derivatives_quote;
END
GO


/* Delete Derivatives Order and Trade books */

IF OBJECT_ID(N'dbo.sp_delete_st_derivatives_books','P') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_delete_st_derivatives_books
END
GO

CREATE PROC dbo.sp_delete_st_derivatives_books
AS		
BEGIN
	DELETE FROM st_derivatives_tradebook;
	DELETE FROM st_derivatives_orderbook;
END
GO



/* Update into EOD StatsBook */

IF OBJECT_ID(N'dbo.sp_update_st_trading_eod_statsbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_update_st_trading_eod_statsbook
END
GO

CREATE PROC dbo.sp_update_st_trading_eod_statsbook

	@contract_name					varchar(100),
	@trade_date						datetime,
	@brokerage   				    decimal(12, 2),
	@expected_profit				decimal(12, 2),
	@min_price						decimal(12, 2),
	@max_price						decimal(12, 2),
	@quantity						int,
	@num_trades						int,
	@num_profit_trades				int,
	@num_loss_trades				int,
	@average_profit_pertrade		decimal(12, 2),
	@average_loss_pertrade			decimal(12, 2),
	@roi_percentage					decimal(12, 2),
	@actual_roi_percentage			decimal(12, 2),
	@actual_profit					decimal(12, 2),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
	@inmarket_time_in_minutes		int,
	@number_of_ticks				int,
	@status_update_time				datetime,
	@r1								varchar(100),
	@r2								varchar(100),

	@upsertStatus					BIT OUTPUT
	
AS
BEGIN

	UPDATE 
		st_trading_eod_statsbook 
	SET 
		min_price = @min_price,
		max_price = @max_price,
		quantity = @quantity,
		brokerage = @brokerage,
		r1 = @r1,
		r2 = @r2,
		expected_profit = @expected_profit,
		actual_profit = @actual_profit,
		num_trades = @num_trades,
		num_profit_trades = @num_profit_trades,
		num_loss_trades = @num_loss_trades,
		average_profit_pertrade = @average_profit_pertrade,
		average_loss_pertrade = @average_loss_pertrade,
		roi_percentage = @roi_percentage,
		actual_roi_percentage = @actual_roi_percentage,
		market_direction_percentage = @market_direction_percentage,
		algo_id = @algo_id,
		inmarket_time_in_minutes = @inmarket_time_in_minutes,
		number_of_ticks = @number_of_ticks,
		status_update_time = @status_update_time 
	WHERE 
		contract_name = @contract_name and
		trade_date = @trade_date and
		market_direction_percentage = @market_direction_percentage and 
		algo_id = @algo_id

	IF @@ERROR = 0 
		BEGIN
			SET @upsertStatus = 1
		END 

END
GO

/* Insert into EOD StatsBook */

IF OBJECT_ID(N'dbo.sp_insert_st_trading_eod_statsbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_insert_st_trading_eod_statsbook
END
GO

CREATE PROC dbo.sp_insert_st_trading_eod_statsbook

	@contract_name					varchar(100),
	@trade_date						datetime,
	@brokerage   				    decimal(12, 2),
	@expected_profit				decimal(12, 2),
	@min_price						decimal(12, 2),
	@max_price						decimal(12, 2),
    @quantity						int,
	@num_trades						int,
	@num_profit_trades				int,
	@num_loss_trades				int,
	@average_profit_pertrade		decimal(12, 2),
	@average_loss_pertrade			decimal(12, 2),
	@roi_percentage					decimal(12, 2),
	@actual_roi_percentage			decimal(12, 2),
	@actual_profit					decimal(12, 2),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
	@inmarket_time_in_minutes		int,
	@number_of_ticks				int,
	@status_update_time				datetime,
	@r1								varchar(100),
	@r2								varchar(100),

	@insertStatus					BIT OUTPUT
	
AS
BEGIN
		INSERT INTO st_trading_eod_statsbook
		(
			contract_name,
			trade_date,
			brokerage,
			expected_profit,
			min_price,
			max_price,
			quantity,
			num_trades,
			num_profit_trades,
			num_loss_trades,
			average_profit_pertrade,
			average_loss_pertrade,
			roi_percentage,
			actual_profit,
			actual_roi_percentage,
			market_direction_percentage,
			algo_id,
			inmarket_time_in_minutes,
			number_of_ticks,
			status_update_time,
			r1,
			r2
		)
		VALUES
		(
			@contract_name,
			@trade_date,
			@brokerage,
			@expected_profit,
			@min_price,
			@max_price,
			@quantity,
			@num_trades,
			@num_profit_trades,
			@num_loss_trades,
			@average_profit_pertrade,
			@average_loss_pertrade,
			@roi_percentage,
			@actual_profit,
			@actual_roi_percentage,
			@market_direction_percentage,
			@algo_id,
			@inmarket_time_in_minutes,
			@number_of_ticks,
			@status_update_time,
			@r1,
			@r2
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO


/* Upsert into EOD StatsBook */

IF OBJECT_ID(N'dbo.sp_upsert_st_trading_eod_statsbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_upsert_st_trading_eod_statsbook
END
GO

CREATE PROC dbo.sp_upsert_st_trading_eod_statsbook

	@contract_name					varchar(100),
	@trade_date						datetime,
	@brokerage   				    decimal(12, 2),
	@expected_profit				decimal(12, 2),
	@min_price						decimal(12, 2),
	@max_price						decimal(12, 2),
		@quantity						int,
	@num_trades						int,
	@num_profit_trades				int,
	@num_loss_trades				int,
	@average_profit_pertrade		decimal(12, 2),
	@average_loss_pertrade			decimal(12, 2),
	@actual_roi_percentage			decimal(12, 2),
	@actual_profit					decimal(12, 2),
	@roi_percentage					decimal(12, 2),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
	@inmarket_time_in_minutes		int,
	@number_of_ticks				int,
	@status_update_time				datetime,
	@r1								varchar(100),
	@r2								varchar(100),

	@upsertStatus	BIT OUTPUT
	
AS
BEGIN

	IF EXISTS (SELECT * FROM st_trading_eod_statsbook WHERE contract_name = @contract_name and trade_date = @trade_date and
		market_direction_percentage = @market_direction_percentage and 
		algo_id = @algo_id)

		EXEC sp_update_st_trading_eod_statsbook 
			@contract_name,
			@trade_date,
			@brokerage,
			@expected_profit,
			@min_price,
			@max_price,
			@quantity,
			@num_trades,
			@num_profit_trades,
			@num_loss_trades,
			@average_profit_pertrade,
			@average_loss_pertrade,
			@roi_percentage,
			@actual_roi_percentage,
			@actual_profit,
			@market_direction_percentage,
			@algo_id,
			@inmarket_time_in_minutes,
			@number_of_ticks,
			@status_update_time,
			@r1,
			@r2,
			@upsertStatus;

	ELSE

		EXEC sp_insert_st_trading_eod_statsbook 
			@contract_name,
			@trade_date,
			@brokerage,
			@expected_profit,
			@min_price,
			@max_price,
			@quantity,
			@num_trades,
			@num_profit_trades,
			@num_loss_trades,
			@average_profit_pertrade,
			@average_loss_pertrade,
			@roi_percentage,
			@actual_roi_percentage,
			@actual_profit,
			@market_direction_percentage,
			@algo_id,
			@inmarket_time_in_minutes,
			@number_of_ticks,
			@status_update_time,
			@r1,
			@r2,
			@upsertStatus;

END
GO



/* Update into EOP StatsBook */

IF OBJECT_ID(N'dbo.sp_update_st_trading_eop_statsbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_update_st_trading_eop_statsbook
END
GO

CREATE PROC dbo.sp_update_st_trading_eop_statsbook

	@contract_name					varchar(100),
	@start_date						datetime,
	@end_date						datetime,
	@num_days						int,
	@brokerage   				    decimal(12, 2),
	@expected_profit				decimal(12, 2),
	@actual_profit					decimal(12, 2),
	@min_price						decimal(12, 2),
	@max_price						decimal(12, 2),
		@quantity						int,
	@average_trade_price			decimal(12, 2),
	@num_trades						int,
	@num_profit_trades				int,
	@num_loss_trades				int,
	@average_profit_pertrade		decimal(12, 2),
	@average_loss_pertrade			decimal(12, 2),
	@roi_percentage					decimal(12, 2),
	@actual_roi_percentage			decimal(12, 2),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
	@inmarket_time_in_minutes		int,
	@number_of_ticks				int,
	@status_update_time				datetime,
	@r1								varchar(100),
	@r2								varchar(100),

	@upsertStatus					BIT OUTPUT
	
AS
BEGIN

	UPDATE 
		st_trading_eop_statsbook 
	SET 
		brokerage = @brokerage,
		r1 = @r1,
		r2 = @r2,
		min_price = @min_price,
		max_price = @max_price,
		quantity = @quantity,
		average_trade_price = @average_trade_price,
		expected_profit = @expected_profit,
		num_trades = @num_trades,
		num_profit_trades = @num_profit_trades,
		num_loss_trades = @num_loss_trades,
		average_profit_pertrade = @average_profit_pertrade,
		average_loss_pertrade = @average_loss_pertrade,
		actual_profit = @actual_profit,
		roi_percentage = @roi_percentage,
		actual_roi_percentage = @actual_roi_percentage,
		--market_direction_percentage = @market_direction_percentage,
		--algo_id = @algo_id,
		num_days = @num_days,
		inmarket_time_in_minutes = @inmarket_time_in_minutes,
		number_of_ticks = @number_of_ticks,
		status_update_time = @status_update_time 
	WHERE 
		contract_name = @contract_name and
		start_date = @start_date and
		end_date = @end_date and
		market_direction_percentage = @market_direction_percentage and 
		algo_id = @algo_id

	IF @@ERROR = 0 
		BEGIN
			SET @upsertStatus = 1
		END 

END
GO

/* Insert into EOP StatsBook */

IF OBJECT_ID(N'dbo.sp_insert_st_trading_eop_statsbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_insert_st_trading_eop_statsbook
END
GO

CREATE PROC dbo.sp_insert_st_trading_eop_statsbook

	@contract_name					varchar(100),
	@start_date						datetime,
	@end_date						datetime,
	@num_days						int,
	@brokerage   				    decimal(12, 2),
	@expected_profit				decimal(12, 2),
	@actual_profit					decimal(12, 2),
	@min_price						decimal(12, 2),
	@max_price						decimal(12, 2),
		@quantity						int,
	@average_trade_price			decimal(12, 2),
	@num_trades						int,
	@num_profit_trades				int,
	@num_loss_trades				int,
	@average_profit_pertrade		decimal(12, 2),
	@average_loss_pertrade			decimal(12, 2),
	@roi_percentage					decimal(12, 2),
	@actual_roi_percentage			decimal(12, 2),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
	@inmarket_time_in_minutes		int,
	@number_of_ticks				int,
	@status_update_time				datetime,
	@r1								varchar(100),
	@r2								varchar(100),

	@insertStatus					BIT OUTPUT
	
AS
BEGIN
		INSERT INTO st_trading_eop_statsbook
		(
			contract_name,
			start_date,
			end_date,
			num_days,
			brokerage,
			expected_profit,
			actual_profit,
			min_price,
			max_price,
			quantity,
			average_trade_price,
			num_trades,
			num_profit_trades,
			num_loss_trades,
			average_profit_pertrade,
			average_loss_pertrade,
			roi_percentage,
			actual_roi_percentage,
			market_direction_percentage,
			algo_id,
			inmarket_time_in_minutes,
			number_of_ticks,
			status_update_time,
			r1,
			r2
		)
		VALUES
		(
			@contract_name,
			@start_date,
			@end_date,
			@num_days,
			@brokerage,
			@expected_profit,
			@actual_profit,
			@min_price,
			@max_price,
			@quantity,
			@average_trade_price,
			@num_trades,
			@num_profit_trades,
			@num_loss_trades,
			@average_profit_pertrade,
			@average_loss_pertrade,
			@roi_percentage,
			@actual_roi_percentage,
			@market_direction_percentage,
			@algo_id,
			@inmarket_time_in_minutes,
			@number_of_ticks,
			@status_update_time,
			@r1,
			@r2
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO


/* Upsert into EOP StatsBook */

IF OBJECT_ID(N'dbo.sp_upsert_st_trading_eop_statsbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_upsert_st_trading_eop_statsbook
END
GO

CREATE PROC dbo.sp_upsert_st_trading_eop_statsbook

	@contract_name					varchar(100),
	@start_date						datetime,
	@end_date						datetime,
	@num_days						int,
	@brokerage   				    decimal(12, 2),
	@expected_profit				decimal(12, 2),
	@actual_profit					decimal(12, 2),
	@min_price						decimal(12, 2),
	@max_price						decimal(12, 2),
		@quantity						int,
	@average_trade_price			decimal(12, 2),
	@num_trades						int,
	@num_profit_trades				int,
	@num_loss_trades				int,
	@average_profit_pertrade		decimal(12, 2),
	@average_loss_pertrade			decimal(12, 2),
	@roi_percentage					decimal(12, 2),
	@actual_roi_percentage			decimal(12, 2),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
	@inmarket_time_in_minutes		int,
	@number_of_ticks				int,
	@status_update_time				datetime,
	@r1								varchar(100),
	@r2								varchar(100),

	@upsertStatus	BIT OUTPUT
	
AS
BEGIN

	IF EXISTS (SELECT * FROM st_trading_eop_statsbook WHERE contract_name = @contract_name and start_date = @start_date and end_date = @end_date and
		market_direction_percentage = @market_direction_percentage and 
		algo_id = @algo_id)

		EXEC sp_update_st_trading_eop_statsbook 
			@contract_name,
			@start_date,
			@end_date,
			@num_days,
			@brokerage,
			@expected_profit,
			@actual_profit,
			@min_price,
			@max_price,
			@quantity,
			@average_trade_price,
			@num_trades,
			@num_profit_trades,
			@num_loss_trades,
			@average_profit_pertrade,
			@average_loss_pertrade,
			@roi_percentage,
			@actual_roi_percentage,
			@market_direction_percentage,
			@algo_id,
			@inmarket_time_in_minutes,
			@number_of_ticks,
			@status_update_time,
			@r1,
			@r2,
			@upsertStatus;

	ELSE

		EXEC sp_insert_st_trading_eop_statsbook 
			@contract_name,
			@start_date,
			@end_date,
			@num_days,
			@brokerage,
			@expected_profit,
			@actual_profit,
			@min_price,
			@max_price,
			@quantity,
			@average_trade_price,
			@num_trades,
			@num_profit_trades,
			@num_loss_trades,
			@average_profit_pertrade,
			@average_loss_pertrade,
			@roi_percentage,
			@actual_roi_percentage,
			@market_direction_percentage,
			@algo_id,
			@inmarket_time_in_minutes,
			@number_of_ticks,
			@status_update_time,
			@r1,
			@r2,
			@upsertStatus;

END
GO

/* Select from EOP StatsBook */

IF OBJECT_ID(N'dbo.sp_select_st_trading_eop_statsbook','U') IS NOT NULL 
BEGIN
	DROP PROC dbo.sp_select_st_trading_eop_statsbook
END
GO

CREATE PROC dbo.sp_select_st_trading_eop_statsbook

	@contract_name					varchar(100),
	--@start_date						datetime,
	--@end_date						datetime,
	--@num_days						int,
	--@expected_profit				decimal(12, 2),
	--@actual_profit					decimal(12, 2),
	--@average_trade_price			decimal(12, 2),
	--@num_trades						int,
	--@num_profit_trades				int,
	--@num_loss_trades				int,
	--@average_profit_pertrade		decimal(12, 2),
	--@average_loss_pertrade			decimal(12, 2),
	--@roi_percentage					decimal(12, 2),
	--@actual_roi_percentage			decimal(12, 2),
	@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
	@r1								varchar(100),
	@r2								varchar(100)
	--@inmarket_time_in_minutes		int,
	--@number_of_ticks				int,
	--@status_update_time				datetime,

	--@upsertStatus					BIT OUTPUT
	
AS
BEGIN

	SELECT * FROM 
		st_trading_eop_statsbook 
	
	WHERE 
		contract_name = @contract_name and
		--start_date = @start_date and
		--end_date = @end_date and
		market_direction_percentage = @market_direction_percentage and 
		algo_id = @algo_id and 
		(r1 IS NULL or r1 = @r1) and 
		(r2 IS NULL or r2 = @r2)
END
GO

--/* Derivatives OrderBook */

--IF OBJECT_ID(N'dbo.st_derivatives_orderbook','U') IS NOT NULL 
--BEGIN
--	DROP TABLE dbo.st_derivatives_orderbook
--END
--GO

--CREATE TABLE dbo.st_derivatives_orderbook
--(
--	contract_name		varchar(100),
--	order_date			datetime     default GETDATE(),
--	order_ref			varchar(30)     ,
--	direction			smallint     ,
--	qty					int     ,
--	price				decimal(12, 2)     ,
--	status				smallint   ,
--	qty_open			int	,
--	qty_executed		int	,
--	qty_cancelled		int	,
--	qty_expired			int	,
--	stoploss_price		decimal(12, 2)	,
--	exchange			smallint	,
--	algo_id				smallint     ,
--	status_update_time	datetime	
--)
--GO



--/* Derivatives OrderBook */

--IF OBJECT_ID(N'dbo.st_derivatives_quote','U') IS NOT NULL 
--BEGIN
--	DROP TABLE dbo.st_derivatives_quote
--END
--GO

--CREATE TABLE dbo.st_derivatives_quote
--(
--	contract_name			varchar(100)     ,
--	quote_time				datetime     ,
--	instrument_type			smallint     ,
--	last_trade_price		decimal(12, 2)     ,
--	asset_underlying		varchar(50)     ,
--	asset_price				decimal(12, 2)     ,
--	bid_price				decimal(12, 2)     ,
--	offer_price				decimal(12, 2)     ,
--	bid_qty					int     ,
--	offer_qty				int     ,
--	traded_qty				int     ,
--	exchange				smallint     
--)
--GO

ROLLBACK