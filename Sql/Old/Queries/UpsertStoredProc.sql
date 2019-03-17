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
	@price				decimal(18, 0)     ,
	@exchange			smallint	,
	@algoId				smallint     ,
	@statusUpdateAt		datetime	,

	@stoplossPrice		decimal(18, 0)     ,
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