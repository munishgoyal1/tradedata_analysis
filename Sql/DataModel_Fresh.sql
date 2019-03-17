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
 * Product - TradingExperiment
 * Product code - st
 * Table structure to hold report information
 */


 --SYMBOL	SERIES	OPEN	HIGH	LOW	CLOSE	LAST	PREVCLOSE	TOTTRDQTY	TOTTRDVAL	TIMESTAMP	TOTALTRADES	ISIN

 DROP TABLE [dbo].[nse_eod_eq]
 GO

CREATE TABLE dbo.nse_eod_eq
(
	symbol					varchar(50) not null	,
	series					varchar(6)     not null,
	open_price				decimal(12, 2)     not null,
	high_price				decimal(12, 2)     not null,
	low_price				decimal(12, 2)     not null,
	close_price				decimal(12, 2)     not null,
	last_price				decimal(12, 2)     not null,
	prevclose_price			decimal(12, 2)     not null,
	qty						int     not null,
	val						decimal(15, 2)     default 0,
	trddate					date not null,
	numtrades				int     default 0 null,
	isin					varchar(50) null
)
GO

DROP TABLE [dbo].nse_eod_eq_analysis
 GO
CREATE TABLE dbo.nse_eod_eq_analysis
(
	symbol					varchar(50) not null	,
	series					varchar(6)     not null,
	high_to_low_pct			decimal(12, 4)     not null,
	highpct_to_prev			decimal(12, 4)     not null,
	lowpct_to_prev			decimal(12, 4)     not null,
	highpct_to_open			decimal(12, 4)     not null,
	lowpct_to_open			decimal(12, 4)     not null,
	openpct_to_prev			decimal(12, 4)     not null,
	open_price				decimal(12, 2)     not null,
	high_price				decimal(12, 2)     not null,
	low_price				decimal(12, 2)     not null,
	close_price				decimal(12, 2)     not null,
	last_price				decimal(12, 2)     not null,
	prevclose_price			decimal(12, 2)     not null,
	qty						int     not null,
	val						decimal(15, 2)     default 0,
	trddate					date not null,
	numtrades				int     default 0 null,
	isin					varchar(50) null
)
GO




--22-Jun-2011 started with more data
