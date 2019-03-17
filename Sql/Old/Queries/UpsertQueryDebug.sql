/* Upsert into Derivatives OrderBook */

DECLARE  @upsertStatus bit

EXEC sp_upsert_st_derivatives_orderbook 

"aa", "1/1/1753", "1dede", 1, 1, 1, 1, 1, "1/1/2001", 1, 1, 1, 1, 1, 1, @upsertStatus;
--@contractName, @orderDate, @orderRef, @direction, @qty, @price, @exchange, 
--	@algoId, @statusUpdateAt, @stoplossPrice, @orderStatus, @qtyOpen, 
--	@qtyExecuted, @qtyCancelled, @qtyExpired, @upsertStatus;

