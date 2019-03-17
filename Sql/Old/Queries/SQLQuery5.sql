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

IF OBJECT_ID(N'dbo.st_derivatives_tradebook','U') IS NOT NULL 
BEGIN
	DROP TABLE dbo.st_derivatives_tradebook
END
GO

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

IF OBJECT_ID(N'dbo.st_derivatives_orderbook','U') IS NOT NULL 
BEGIN
	DROP TABLE dbo.st_derivatives_orderbook
END
GO

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

IF OBJECT_ID(N'dbo.st_derivatives_quote','U') IS NOT NULL 
BEGIN
	DROP TABLE dbo.st_derivatives_quote
END
GO

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

IF OBJECT_ID(N'dbo.st_trading_eod_statsbook','U') IS NOT NULL 
BEGIN
	DROP TABLE dbo.st_trading_eod_statsbook
END
GO

CREATE TABLE dbo.st_trading_eod_statsbook
(
	contract_name				varchar(100)		not null,
	trade_date					datetime			default GETDATE(),
	market_direction_percentage	decimal(12, 2)		not null,
	actual_roi_percentage		decimal(12, 2)		not null,
	actual_profit				decimal(12, 2)		not null,
	roi_percentage				decimal(12, 2)		not null,
	expected_profit				decimal(12, 2)		not null,
	num_trades					int					not null,
	num_profit_trades			int					not null,
	num_loss_trades				int					not null,
	average_profit_pertrade		decimal(12, 2)		not null,
	average_loss_pertrade		decimal(12, 2)		not null,
	inmarket_time_in_minutes	int					not null,
	number_of_ticks				int					not null,
	algo_id						smallint			not null,
	status_update_time			datetime			default GETDATE()
)
GO

/* EOP StatsBook */

IF OBJECT_ID(N'dbo.st_trading_eop_statsbook','U') IS NOT NULL 
BEGIN
	DROP TABLE dbo.st_trading_eop_statsbook
END
GO

CREATE TABLE dbo.st_trading_eop_statsbook
(
	contract_name				varchar(100)		not null,
	start_date					datetime			default GETDATE(),
	end_date					datetime			default GETDATE(),
	market_direction_percentage	decimal(12, 2)		not null,
	actual_roi_percentage		decimal(12, 2)		not null,
	actual_profit				decimal(12, 2)		not null,
	roi_percentage				decimal(12, 2)		not null,
	expected_profit				decimal(12, 2)		not null,
	min_price					decimal(12, 2)		not null,
	max_price					decimal(12, 2)		not null,
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
	status_update_time			datetime			default GETDATE()
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

/* EOD StatsBook */

IF EXISTS (SELECT name FROM sysindexes WHERE name = N'dbo.st_trading_eod_statsbook_Summary____00001')
BEGIN
    DROP INDEX st_trading_eod_statsbook_Summary____00001 on dbo.st_trading_eod_statsbook
END
GO

CREATE INDEX st_trading_eod_statsbook_Summary____00001
    ON dbo.st_trading_eod_statsbook (contract_name, market_direction_percentage)
GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold competitors analyzed
-- */
--IF OBJECT_ID(N'dbo.st_competitors','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_competitors
--END
--GO

--CREATE TABLE dbo.st_competitors
--(
--	job_id							VARCHAR(50)		not null,
--	report_id						SMALLINT		not null,
--    url_no   						SMALLINT		not null,
--    competitor_url					VARCHAR(2048)	not null,
--    search_engine					SMALLINT        not null,
--    type_of_entry                   SMALLINT        not null default 0
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold on page analysis
-- */
--IF OBJECT_ID(N'dbo.st_onPageAnalysis','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_onPageAnalysis
--END
--GO

--CREATE TABLE dbo.st_onPageAnalysis
--(
--	job_id							VARCHAR(50)		not null,
--	report_id						SMALLINT		not null,
--	search_engine					SMALLINT		not null,
--	query                           NVARCHAR(500)   not null,
--	original_query					NVARCHAR(500)	not null,
--	query_weight                    DECIMAL(38,2)   not null,
--	query_group						VARCHAR(32)		not null,
--	query_strength					DECIMAL(9,6)	not null,
--	type_of_query                   INT             not null,
--	url								VARCHAR(2048)	not null, 
--    url_no   						SMALLINT		not null, 
--	url_score						DECIMAL(38,6)	not null, 
--	zone							VARCHAR(50)		not null, 
--	zone_weight						DECIMAL(9,6)	not null, 
--	zone_instance					SMALLINT		not null, 
--	emphasis_score                  DECIMAL(19,10)  not null,
--	max_emphasis_score              DECIMAL(19,10)  not null,
--	scaled_emphasis_score			DECIMAL(19,10)	not null, 
--	late_occurence_penalty			DECIMAL(9,6)	not null, 
--	spam_penalty					DECIMAL(9,6)	not null, 
--	weighted_query_score            DECIMAL(38,6)   not null,
--	start_location					INT				not null, 
--	end_location					INT				not null, 
--	first_occurence_of_query		INT				not null, 
--	processing_status               INT             null
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold off page analysis
-- */
--IF OBJECT_ID(N'dbo.st_offPageAnalysis','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_offPageAnalysis
--END
--GO

--CREATE TABLE dbo.st_offPageAnalysis
--(
--	job_id							VARCHAR(50)		not null,
--	report_id						SMALLINT		not null,
--	search_engine					SMALLINT		not null,
--	query                           NVARCHAR(500)   not null,
--	original_query					NVARCHAR(500)	not null,
--	query_weight                    DECIMAL(38,2)   not null,
--	query_group						VARCHAR(32)		not null,
--	query_strength					DECIMAL(9,6)	not null,
--	type_of_query                   INT             not null,
--	url								VARCHAR(2048)	not null, 
--    url_no   						SMALLINT		not null, 
--	url_score						DECIMAL(38,6)	not null, 
--	url_vote_score					DECIMAL(38,6)	not null, 
--	url_set_id                      INT             not null,
--	off_page_scale_up               DECIMAL(9,6)    not null,
--	zone							VARCHAR(50)		not null, 
--	zone_weight						DECIMAL(9,6)	not null, 
--	zone_instance					SMALLINT		not null, 
--	emphasis_score                  DECIMAL(19,10)  not null,
--	max_emphasis_score              DECIMAL(19,10)  not null,
--	scaled_emphasis_score			DECIMAL(19,10)	not null, 
--	contextual_zone_weight          DECIMAL(9,6)    not null,
--	late_occurence_penalty			DECIMAL(9,6)	not null, 
--	spam_penalty					DECIMAL(9,6)	not null, 
--	weighted_query_score            DECIMAL(38,6)   not null,
--	start_location					INT				not null, 
--	end_location					INT				not null, 
--	first_occurence_of_query		INT				not null, 
--	processing_status               INT             null
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold on page recommendations
-- */
--IF OBJECT_ID(N'dbo.st_onPageRecommendations','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_onPageRecommendations
--END
--GO

--CREATE TABLE dbo.st_onPageRecommendations
--(
--	job_id							VARCHAR(50)		not null,
--    rule_seq_no						SMALLINT        not null,
--    rule_name                       VARCHAR(100)    not null,
--	report_id						SMALLINT		not null,
--    url_no   						SMALLINT		not null,
--    search_engine					SMALLINT		not null, 
--    url								VARCHAR(2048)	not null, 
--    performance_indicator		    SMALLINT        not null,
--    recommendation                  VARCHAR(5000)   not null
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold off page recommendations
-- */
--IF OBJECT_ID(N'dbo.st_offPageRecommendations','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_offPageRecommendations
--END
--GO

--CREATE TABLE dbo.st_offPageRecommendations
--(
--	job_id							VARCHAR(50)		not null,
--	report_id						SMALLINT		not null,
--    url_no   						SMALLINT		not null,
--    search_engine                   SMALLINT		not null,
--    citation_from					VARCHAR(2048)	not null,
--	citation_from_normalized		VARCHAR(2048)	not null,
--	is_canonical_duplicate			BIT				not null,
--    citation_score					DECIMAL(38,6)	not null,
--    citation_vote_score				DECIMAL(38,6)	not null,
--    citation_scale_up				DECIMAL(19,10)  not null,
--    citation_type					SMALLINT        not null, -- Field for contenxtual/non-contextual etc
--    citation_category				SMALLINT        not null,
--    citation_relevancy_to_phrase	SMALLINT		not null,
--    citation_performance_indicator  SMALLINT	    not null
--)
--GO



--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold logs
-- */
--IF OBJECT_ID(N'dbo.st_logs','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_logs
--END
--GO
--CREATE TABLE dbo.st_logs
--(
--	id								VARCHAR(50) NOT NULL,
--	process_id						int NULL,
--	status_message					varchar(800) NULL,
--	log_time						datetime default GETDATE()
--)
--GO


--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold final scores computed after analysis
-- */
--IF OBJECT_ID(N'dbo.st_finalUrlScores','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_finalUrlScores
--END
--GO
--CREATE TABLE dbo.st_finalUrlScores
--(
--	job_id							VARCHAR(50)		not null,
--	report_id						SMALLINT NOT NULL,
--	search_engine					smallint NOT NULL,
--	url_no							smallint NOT NULL,
--	url_score						decimal(38, 6) NULL,
--	onpage_score					decimal(38, 6) NULL,
--	max_onpage_score				decimal(38, 6) NULL,
--	offpage_score					decimal(38, 6) NULL,
--	max_offpage_score				decimal(38, 6) NULL
--) 
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold on job Information
-- */
--IF OBJECT_ID(N'dbo.st_job','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_job
--END
--GO

--CREATE TABLE dbo.st_job
--(
--	job_id							VARCHAR(50)		not null PRIMARY KEY,
--	user_id							NVARCHAR(256)   not null,
--	created_on						DATETIME        default GETDATE(),
--	completed_at					DATETIME        default GETDATE(),
--	current_state					SMALLINT        not null,
--	status_code						SMALLINT		not null,
--	state_ready_time				DATETIME        default GETDATE(),
--	state_retry_count				SMALLINT		not null,
--	unique_processing_id			VARCHAR(100)	not null
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold on job run history info
-- */
--IF OBJECT_ID(N'dbo.st_jobHistory','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_jobHistory
--END
--GO

--CREATE TABLE dbo.st_jobHistory
--(
--	job_id							VARCHAR(50)		not null,
--	state_id						SMALLINT		not null,
--	entered_at						DATETIME        default GETDATE(),
--	exited_at						DATETIME        default GETDATE(),
--	status_code						SMALLINT		not null,
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold on invoice Information
-- */
--IF OBJECT_ID(N'dbo.st_invoice','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_invoice
--END
--GO

--CREATE TABLE dbo.st_invoice
--(
--	invoice_id						VARCHAR(50)		not null PRIMARY KEY,
--	user_id							NVARCHAR(256)	not null,
--	created_on						DATETIME        default GETDATE(),
--	first_updated_on				DATETIME        default GETDATE(),
--	invoice_status					SMALLINT		not null,
--	transaction_status				VARCHAR(50)		not null,
--	transaction_id					VARCHAR(50)		not null,
--	payment_provider				VARCHAR(50)		not null,
--	amount							DECIMAL(38, 2)	not null,
--	currency_code					CHAR(3)			not null,
--	credits							INT				not null,
--	custom_ref_id					VARCHAR(50)		not null
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold support ticket information
-- */
--IF OBJECT_ID(N'dbo.st_supportTicket','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_supportTicket
--END
--GO

--CREATE TABLE dbo.st_supportTicket
--(
--	ticket_id						INT				not null IDENTITY(1,1) PRIMARY KEY,
--	user_id							NVARCHAR(256)	not null,
--	created_on						DATETIME        default GETDATE(),
--	updated_on						DATETIME        default GETDATE(),
--	is_active						BIT				not null,
--	ticket_status					VARCHAR(50)		not null,
--	report_reference				VARCHAR(100)	not null,
--	category						VARCHAR(50)		not null,
--	title							VARCHAR(256)	not null,
--    latest_activity_doneby          NVARCHAR(256)	not null
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold support ticket conversation
-- */
--IF OBJECT_ID(N'dbo.st_supportConversation','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_supportConversation
--END
--GO

--CREATE TABLE dbo.st_supportConversation
--(
--	conversation_id					INT				not null IDENTITY(1,1) PRIMARY KEY,
--	ticket_id						VARCHAR(50)		not null,
--	created_on						DATETIME        default GETDATE(),
--	author							NVARCHAR(256)	not null,
--	text							TEXT
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold file information
-- */
--IF OBJECT_ID(N'dbo.st_fileStorage','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_fileStorage
--END
--GO

--CREATE TABLE dbo.st_fileStorage
--(
--	file_id							INT					not null IDENTITY(1,1) PRIMARY KEY,
--	file_encoding					VARCHAR(50)			not null,
--	file_content_type				VARCHAR(50)			not null,
--	file_name						NVARCHAR(256)		not null,
--	file_content					VARBINARY(MAX)		not null,
--	created_on						DATETIME			default GETDATE()
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold conversation-attachment mapping
-- */
--IF OBJECT_ID(N'dbo.st_conversationAttachment','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_conversationAttachment
--END
--GO

--CREATE TABLE dbo.st_conversationAttachment
--(
--	file_id							INT		not null,
--	conversation_id					INT		not null
--)
--GO


--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold marketing schemes information
-- */
--IF OBJECT_ID(N'dbo.st_marketingScheme','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_marketingScheme
--END
--GO

--CREATE TABLE dbo.st_marketingScheme
--(
--	scheme_id						VARCHAR(50)		not null PRIMARY KEY,
--	scheme							VARCHAR(256)	null,
--	details							VARCHAR(800)	null,
--	created_on						DATETIME        default GETDATE()
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold marketing campaigns information
-- */
--IF OBJECT_ID(N'dbo.st_marketingCampaign','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_marketingCampaign
--END
--GO

--CREATE TABLE dbo.st_marketingCampaign
--(
--	campaign_id						VARCHAR(50)		not null PRIMARY KEY,
--	campaign						VARCHAR(500)	null,
--	scheme_id						VARCHAR(50)		not null,
--	details							VARCHAR(800)	null,
--	start_time						DATETIME        default GETDATE(),
--	end_time						DATETIME		null
--)
--GO


--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold coupon information
-- */
--IF OBJECT_ID(N'dbo.st_coupon','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_coupon
--END
--GO

--CREATE TABLE dbo.st_coupon
--(
--	coupon_id						VARCHAR(50)		not null PRIMARY KEY,
--	coupon_type						SMALLINT		not null,
--	coupon_code						VARCHAR(50)		not null,
--	points							DECIMAL(19, 10) not null,
--	is_free_coupon					BIT				default 1,
--	creation_time					DATETIME        default GETDATE(),
--	expiry_time						DATETIME		null,
--	redeem_time						DATETIME		null,
--	redeemed_user_id				NVARCHAR(256)	null,
--	invoice_id						VARCHAR(50)		null
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold coupon campaing mapping information
-- */
--IF OBJECT_ID(N'dbo.st_couponCampaignMapping','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_couponCampaignMapping
--END
--GO

--CREATE TABLE dbo.st_couponCampaignMapping
--(
--	coupon_id						VARCHAR(50)		not null,
--	campaign_id						VARCHAR(50)		not null,
--	details							VARCHAR(800)	null
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold coupon invoice mapping information
-- */
--IF OBJECT_ID(N'dbo.st_couponInvoiceMapping','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_couponInvoiceMapping
--END
--GO

--CREATE TABLE dbo.st_couponInvoiceMapping
--(
--	coupon_id						VARCHAR(50)		not null,
--	invoice_id						VARCHAR(50)		not null
--)
--GO

--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * Table structure to hold temporary reports information of a new user
-- */
--IF OBJECT_ID(N'dbo.st_newUserTempJobStorage','U') IS NOT NULL 
--BEGIN
--    DROP TABLE dbo.st_newUserTempJobStorage
--END
--GO

--CREATE TABLE dbo.st_newUserTempJobStorage
--(
--	txRef_id						VARCHAR(50)		not null, 
--	user_id							NVARCHAR(256)	not null,
--	invoice_id						VARCHAR(50)		not null,
--	job_id							VARCHAR(50)		not null, -- For quickly viewing JobID in DB purpose since reports data is in binary form
--    payment_state					SMALLINT		not null, 
--    reports_input					VARBINARY(MAX)	not null,
--    created_on						DATETIME        default GETDATE(),
--	completed_on					DATETIME        default GETDATE()
--)
--GO


--/*
--*****************************************************************
--* *********** INDEXES *******************************************
--* ***************************************************************
--*/

--IF EXISTS (SELECT name FROM sysindexes WHERE name = N'dbo.st_report_Report____00001')
--BEGIN
--    DROP INDEX st_report_Report____00001 on dbo.st_report
--END
--GO

--CREATE UNIQUE INDEX st_report_Report____00001
--    ON dbo.st_report (job_id,report_id)
--GO


--IF EXISTS (SELECT name FROM sysindexes WHERE name = N'dbo.st_competitors_ReportUrlNoSearchEngine____00001')
--BEGIN
--    DROP INDEX st_competitors_ReportUrlNoSearchEngine____00001 on dbo.st_competitors
--END
--GO

--CREATE UNIQUE INDEX st_competitors_ReportUrlNoSearchEngine____00001
--    ON dbo.st_competitors (job_id,report_id,url_no,search_engine)
--GO


--IF EXISTS (SELECT name FROM sysindexes WHERE name = N'dbo.st_OnPageAnalysis_URL____00001')
--BEGIN
--    DROP INDEX st_OnPageAnalysis_URL____00001 on dbo.st_onPageAnalysis
--END
--GO


--CREATE INDEX st_OnPageAnalysis_URL____00001
--    ON dbo.st_onPageAnalysis (url_no)
--GO

--IF EXISTS (SELECT name FROM sysindexes WHERE name = 'st_OnPageAnalysis_Report____00001')
--BEGIN
--    DROP INDEX st_OnPageAnalysis_Report____00001 on dbo.st_onPageAnalysis
--END
--GO

--CREATE INDEX st_OnPageAnalysis_Report____00001
--    ON dbo.st_onPageAnalysis (report_id)
--GO

--IF EXISTS (SELECT name FROM sysindexes WHERE name = 'st_OnPageAnalysis_Zone____00001')
--BEGIN
--    DROP INDEX st_OnPageAnalysis_Zone____00001 on dbo.st_onPageAnalysis
--END
--GO


--CREATE INDEX st_OnPageAnalysis_Zone____00001
--    ON dbo.st_onPageAnalysis (zone,zone_instance)
--GO


--IF EXISTS (SELECT name FROM sysindexes WHERE name = 'st_OffPageAnalysis_URL____00001')
--BEGIN
--    DROP INDEX st_OffPageAnalysis_URL____00001 on dbo.st_offPageAnalysis
--END
--GO

--CREATE INDEX st_OffPageAnalysis_URL____00001
--    ON dbo.st_offPageAnalysis (url_no)
--GO

--IF EXISTS (SELECT name FROM sysindexes WHERE name = 'st_OffPageAnalysis_Report____00001')
--BEGIN
--    DROP INDEX st_OffPageAnalysis_Report____00001 on dbo.st_offPageAnalysis
--END
--GO

--CREATE INDEX st_OffPageAnalysis_Report____00001
--    ON dbo.st_offPageAnalysis (report_id)
--GO

--IF EXISTS (SELECT name FROM sysindexes WHERE name = 'st_OffPageAnalysis_Zone____00001')
--BEGIN
--    DROP INDEX st_OffPageAnalysis_Zone____00001 on dbo.st_offPageAnalysis
--END
--GO

--CREATE INDEX st_OffPageAnalysis_Zone____00001
--    ON dbo.st_offPageAnalysis (zone,zone_instance)
--GO


--IF EXISTS (SELECT name FROM sysindexes WHERE name = 'st_onPageRecommendations_ReportUrlNo____00001')
--BEGIN
--    DROP INDEX st_onPageRecommendations_ReportUrlNo____00001 on dbo.st_onPageRecommendations
--END
--GO

--CREATE INDEX st_onPageRecommendations_ReportUrlNo____00001
--    ON dbo.st_onPageRecommendations (report_id,url_no)
--GO



--IF EXISTS (SELECT name FROM sysindexes WHERE name = 'st_offPageRecommendations_ReportUrlNo____00001')
--BEGIN
--    DROP INDEX st_offPageRecommendations_ReportUrlNo____00001 on dbo.st_offPageRecommendations
--END
--GO

--CREATE INDEX st_offPageRecommendations_ReportUrlNo____00001
--    ON dbo.st_offPageRecommendations (report_id,url_no)
--GO

--IF EXISTS (SELECT name FROM sysindexes WHERE name = 'st_offPageRecommendations_CitationFrom____00001')
--BEGIN
--    DROP INDEX st_offPageRecommendations_CitationFrom____00001 on dbo.st_offPageRecommendations
--END
--GO

--CREATE INDEX st_offPageRecommendations_CitationFrom____00001
--    ON dbo.st_offPageRecommendations (citation_from)
--GO


--/*
--*****************************************************************
--* *********** VIEWS *********************************************
--* ***************************************************************
--*/


--/*
-- * Product - PageDoctor-Report
-- * Product code - pdr
-- * View that holds on page optimization details
-- */
--IF OBJECT_ID(N'dbo.st_onPageOptimization','V') IS NOT NULL 
--BEGIN
--    DROP VIEW dbo.st_onPageOptimization
--END
--GO

--CREATE VIEW dbo.st_onPageOptimization
--AS
--SELECT 
--	url as url,
--	url_no as competitor,
--	zone as zone,
--	MAX(zone_weight) as zone_weight,
--	SUM(query_weight) as score_achieved,
--	SUM(query_weight * zone_weight ) as max_possible_score,
--	pct_optimized = CASE SUM(query_weight * zone_weight)
--		WHEN 0 THEN -1
--		ELSE 100 * (SUM(query_weight * weighted_query_score )/ SUM(query_weight * zone_weight))
--	END,
--	avg_emphasis = CASE SUM(query_weight * zone_weight)
--		WHEN 0 THEN -1
--		ELSE SUM(scaled_emphasis_score * query_weight * zone_weight) / SUM(query_weight * zone_weight)
--	END,
--	avg_lop = CASE SUM(query_weight * zone_weight)
--		WHEN 0 THEN -1
--		ELSE SUM(late_occurence_penalty * query_weight * zone_weight) / SUM(query_weight * zone_weight)
--	END,
--	avg_spam = CASE SUM(query_weight * zone_weight)
--		WHEN 0 THEN -1
--		ELSE SUM(spam_penalty * query_weight * zone_weight) / SUM(query_weight * zone_weight)
--	END
--	FROM
--		st_onPageAnalysis
--	GROUP BY
--		report_id,url,url_no,zone
--GO


--/*
-- * Product - Page Docrtor - Report
-- * Product code - pdr
-- * View that holds off page optimization details
-- */
--IF OBJECT_ID(N'dbo.st_offPageOptimization','V') IS NOT NULL 
--BEGIN
--    DROP VIEW dbo.st_offPageOptimization
--END
--GO

--CREATE VIEW dbo.st_offPageOptimization
--AS
--SELECT 
--	url as url,
--	url_no as competitor,
--	MAX(url_score) as url_score,
--	SUM(weighted_query_score * query_weight) AS score_achieved,
--	SUM(zone_weight * query_weight) AS max_possible_score,
--	SUM(contextual_zone_weight * query_weight * scaled_emphasis_score) AS contextual_score,
--	SUM(query_weight * contextual_zone_weight) AS max_contextual_score,
--	avg_emphasis = CASE SUM(query_weight * zone_weight)
--		WHEN 0 THEN -1
--		ELSE SUM(scaled_emphasis_score * query_weight * zone_weight) / SUM(query_weight * zone_weight)
--	END,
--	avg_lop = CASE SUM(query_weight * zone_weight)
--		WHEN 0 THEN -1
--		ELSE SUM(late_occurence_penalty * query_weight * zone_weight) / SUM(query_weight * zone_weight)
--	END,
--	avg_spam = CASE SUM(query_weight * zone_weight)
--		WHEN 0 THEN -1
--		ELSE SUM(spam_penalty * query_weight * zone_weight) / SUM(query_weight * zone_weight)
--	END
--	FROM
--		st_offPageAnalysis
--	GROUP BY
--		report_id,url,url_no
--GO

