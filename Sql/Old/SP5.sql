SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON         -- We don't want (NULL = NULL) == TRUE
GO

SET ANSI_PADDING ON
GO

SET ANSI_NULL_DFLT_ON ON
GO


/* Create Date: 24/02/2011
 * Purpose: SP5 version for new tables and stored procs
 * Revision No: 1
*/

/*
 * Product - PageDoctor-Report
 * Product code - pdr
 * Table structure to hold primary url meta data information
 */

/*
*****************************************************************
* *********** TABLES ********************************************
* ***************************************************************
*/


 /*
*****************************************************************
* *********** STORED PROCEDURES**********************************
* ***************************************************************
*/
IF OBJECT_ID(N'dbo.sp_select_pdr_offPageRecommendations_leadsCount','P') IS NOT NULL BEGIN
    DROP PROC dbo.sp_select_pdr_offPageRecommendations_leadsCount
END
GO

CREATE PROC dbo.sp_select_pdr_offPageRecommendations_leadsCount
			@jobId			VARCHAR(50),
			@reportId		SMALLINT, 
			@thresholdScore	DECIMAL(38,6)
AS
BEGIN
		SELECT COUNT(*) AS leadCount
	        FROM 
		        (
		        SELECT 
			        opr1.*, 
			        sort_order = DENSE_RANK() OVER (PARTITION BY opr1.Domain ORDER BY  opr1.Score DESC,opr1.Vote_score DESC,opr1.[from] DESC )
		        FROM 
			        pdr_offPageRecommendations opr1
		        WHERE  
			        job_id = @jobId  and
			        report_id = @reportId and
			        is_canonical_duplicate = 0 and
                    url_no <> 0 and
                    score > @thresholdScore                                          
		        ) AS opr
	        WHERE
		            opr.sort_order= 1	    
END
GO

/* Alter the Stored Proc to correct the selection of top url (highest score) from the same domain group*/
ALTER PROC [dbo].[sp_select_pdr_offPageRecommendations]
		@jobId							VARCHAR(50),
		@reportId						SMALLINT,
		@topNRecommendations			INT
AS		
BEGIN

		DECLARE @rowCount INT
        DECLARE @ifOldReport BIT
        
        if exists ( select url_no from pdr_offPageRecommendations
					where job_id = @jobId and report_id = @reportId and url_no = -1)
			set @ifOldReport = 0
		else
			set @ifOldReport = 1
			
		set @rowCount = (SELECT COUNT(*)
                        FROM 
                        (
                        SELECT 
                            opr1.*,
                            sort_order = DENSE_RANK() OVER (PARTITION BY opr1.Domain ORDER BY opr1.Score DESC,opr1.Vote_score DESC,opr1.[from] DESC)
                        FROM 
                            pdr_offPageRecommendations opr1
                        WHERE  
                            job_id = @JobId and
                            report_id = @ReportId and
                            is_canonical_duplicate = 0 and
                            url_no > 0
                        ) AS opr
                    WHERE
                        opr.sort_order= 1 and opr.score > 1000 	                               
                        ) 
                        
		if (@rowCount > @topNRecommendations)
		 set @rowCount = @topNRecommendations
                        
		select * from
			(
	            (SELECT Top(@topNRecommendations)
		            opr.job_id,
		            opr.report_id,
		            opr.url_no,
		            opr.[from],
		            opr.from_normalized,
		            opr.is_canonical_duplicate,
		            opr.score,
		            opr.vote_score,
		            opr.scale_up,
		            opr.[type],
		            opr.category,
		            opr.emphasis_of_phrase_in_citations,
		            opr.performance_indicator,
                    comp_order = 1
	            FROM 
		            (
		            SELECT 
			            opr1.*, 
			            sort_order = DENSE_RANK() OVER (PARTITION BY opr1.Domain ORDER BY opr1.Score DESC,opr1.Vote_score DESC,opr1.[from] DESC)
		            FROM 
			            pdr_offPageRecommendations opr1
		            WHERE  
			            job_id = @JobId and
			            report_id = @ReportId and
			            is_canonical_duplicate = 0 and
                        url_no > 0
		            ) AS opr
	            WHERE
		            opr.sort_order= 1 and opr.score > 
                        case @ifOldReport
							when 0 then 1000
							when 1 then 0
						end	
	            ORDER BY
		            opr.score DESC)

                    Union ALL                       
		                               
		            (SELECT Top(@topNRecommendations - @rowCount)
		            opr.job_id,
		            opr.report_id,
		            opr.url_no,
		            opr.[from],
		            opr.from_normalized,
		            opr.is_canonical_duplicate,
		            opr.score,
		            opr.vote_score,
		            opr.scale_up,
		            opr.[type],
		            opr.category,
		            opr.emphasis_of_phrase_in_citations,
		            opr.performance_indicator,
                    comp_order = 2
	            FROM 
		            (
		            SELECT 
			            opr1.*,			 
			            sort_order = DENSE_RANK() OVER (PARTITION BY opr1.Domain ORDER BY opr1.Score DESC,opr1.Vote_score DESC,opr1.[from] DESC)
		            FROM 
			            pdr_offPageRecommendations opr1
		            WHERE  
			            job_id = @JobId and
			            report_id = @ReportId and
			            is_canonical_duplicate = 0 and
                        url_no = -1
		            ) AS opr
	            WHERE
		            opr.sort_order= 1 
	            ORDER BY
		            opr.score DESC
		            )
            ) as leadList		                               
		    order by leadList.comp_order ASC, leadList.score DESC
END
GO

/* Added input_url in all alexa tables */

ALTER TABLE pdr_alexaUrlInfo ADD input_url varchar(900) not null default 'defaultUrl'
GO

UPDATE T
SET T.input_url = T.alexa_url
FROM pdr_alexaUrlInfo T
GO

ALTER TABLE pdr_alexaRelatedLinks ADD input_url varchar(900) not null default 'defaultUrl'
GO

UPDATE T
SET T.input_url = T.alexa_url
FROM pdr_alexaRelatedLinks T
GO

ALTER TABLE pdr_alexaRelatedCategories ADD input_url varchar(900) not null default 'defaultUrl'
GO

UPDATE T
SET T.input_url = T.alexa_url
FROM pdr_alexaRelatedCategories T
GO

ALTER TABLE pdr_alexaRelatedKeywords ADD input_url varchar(900) not null default 'defaultUrl'
GO

UPDATE T
SET T.input_url = T.alexa_url
FROM pdr_alexaRelatedKeywords T
GO

ALTER TABLE pdr_alexaOwnedDomains ADD input_url varchar(900) not null default 'defaultUrl'
GO

UPDATE T
SET T.input_url = T.alexa_url
FROM pdr_alexaOwnedDomains T
GO

ALTER TABLE pdr_alexaUsageStatistics ADD input_url varchar(900) not null default 'defaultUrl'
GO

UPDATE T
SET T.input_url = T.alexa_url
FROM pdr_alexaUsageStatistics T
GO

ALTER TABLE pdr_alexaContributingSubDomains ADD input_url varchar(900) not null default 'defaultUrl'
GO

UPDATE T
SET T.input_url = T.alexa_url
FROM pdr_alexaContributingSubDomains T
GO


IF OBJECT_ID(N'dbo.sp_delete_pdr_alexaUrlInfo','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_delete_pdr_alexaUrlInfo
END
GO

CREATE PROC dbo.sp_delete_pdr_alexaUrlInfo
			@inputUrl					VARCHAR(900)
AS
BEGIN
	DELETE FROM pdr_alexaOwnedDomains WHERE input_url = @inputUrl
	DELETE FROM pdr_alexaRelatedCategories WHERE input_url  = @inputUrl
	DELETE FROM pdr_alexaRelatedKeywords WHERE input_url  = @inputUrl
	DELETE FROM pdr_alexaRelatedLinks WHERE input_url = @inputUrl
	DELETE FROM pdr_alexaContributingSubDomains WHERE input_url = @inputUrl
	DELETE FROM pdr_alexaUsageStatistics WHERE input_url = @inputUrl
	DELETE FROM pdr_alexaUrlLogs WHERE input_url = @inputUrl
	DELETE FROM pdr_alexaUrlInfo WHERE input_url = @inputUrl
END
GO


IF OBJECT_ID(N'dbo.sp_insert_pdr_alexaUrlInfo','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_insert_pdr_alexaUrlInfo
END
GO

CREATE PROC dbo.sp_insert_pdr_alexaUrlInfo
			@inputUrl					VARCHAR(900),
			@alexaUrl					VARCHAR(900),
			@title						NVARCHAR(MAX),
			@description				NVARCHAR(MAX),
			@onlineSince				DATETIME,
			@age						INT,
			@isAdultContent				BIT,
			@medianLoadTime				INT,
			@speedPercentile			FLOAT,
			@linksInCount				BIGINT,
			@language					NVARCHAR(100),
			@charEncoding				VARCHAR(100),
			@rank						BIGINT,
			@insertStatus				BIT OUTPUT
AS
BEGIN
		EXEC sp_delete_pdr_alexaUrlInfo @inputUrl

		INSERT INTO pdr_alexaUrlInfo
		(
			input_url,
			alexa_url,
			title,
			description,
			online_since,
			age,
			is_adult_content,
			median_load_time,
			speed_percentile,
			links_in_count,
			language,
			char_encoding,
			rank
		)
		VALUES
		(
			@inputUrl,
			@alexaUrl,
			@title,
			@description,
			@onlineSince,
			@age,
			@isAdultContent,
			@medianLoadTime,
			@speedPercentile,
			@linksInCount,
			@language,
			@charEncoding,
			@rank
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO


IF OBJECT_ID(N'dbo.sp_insert_pdr_alexaRelatedCategories','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_insert_pdr_alexaRelatedCategories
END
GO

CREATE PROC dbo.sp_insert_pdr_alexaRelatedCategories
			
			@inputUrl					VARCHAR(900),
			@alexaUrl					VARCHAR(900),
			@absolutePath				NVARCHAR(900),
			@title						NVARCHAR(900),
			@insertStatus				BIT OUTPUT
AS
BEGIN
		INSERT INTO pdr_alexaRelatedCategories
		(
			input_url,
			alexa_url,
			absolute_path,
			title
		)
		VALUES
		(
			@inputUrl,
			@alexaUrl,
			@absolutePath,
			@title
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO	



IF OBJECT_ID(N'dbo.sp_insert_pdr_alexaRelatedLinks','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_insert_pdr_alexaRelatedLinks
END
GO

CREATE PROC dbo.sp_insert_pdr_alexaRelatedLinks
			@inputUrl					VARCHAR(900),
			@alexaUrl					VARCHAR(900),
			@relatedUrl					VARCHAR(900),
			@navigableUrl				VARCHAR(900),
			@title						NVARCHAR(MAX),
			@insertStatus				BIT OUTPUT
AS
BEGIN
		INSERT INTO pdr_alexaRelatedLinks
		(
			input_url,
			alexa_url,
			related_url,
			navigable_url,
			title
		)
		VALUES
		(
			@inputUrl,
			@alexaUrl,
			@relatedUrl,
			@navigableUrl,
			@title
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO	


IF OBJECT_ID(N'dbo.sp_insert_pdr_alexaRelatedKeywords','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_insert_pdr_alexaRelatedKeywords
END
GO

CREATE PROC dbo.sp_insert_pdr_alexaRelatedKeywords
			@inputUrl					VARCHAR(900),
			@alexaUrl					VARCHAR(900),
			@keyword					NVARCHAR(900),
			@insertStatus				BIT OUTPUT
AS
BEGIN
		INSERT INTO pdr_alexaRelatedKeywords
		(
			input_url,
			alexa_url,
			keyword
		)
		VALUES
		(
			@inputUrl,
			@alexaUrl,
			@keyword
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO



IF OBJECT_ID(N'dbo.sp_insert_pdr_alexaOwnedDomains','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_insert_pdr_alexaOwnedDomains
END
GO

CREATE PROC dbo.sp_insert_pdr_alexaOwnedDomains
			@inputUrl					VARCHAR(900),
			@alexaUrl					VARCHAR(900),	
			@domain						VARCHAR(900),
			@title						NVARCHAR(900),
			@insertStatus				BIT OUTPUT
AS
BEGIN
		INSERT INTO pdr_alexaOwnedDomains
		(
			input_url,
			alexa_url,
			domain,
			title
		)
		VALUES
		(
			@inputUrl,
			@alexaUrl,
			@domain,
			@title
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO		


IF OBJECT_ID(N'dbo.sp_insert_pdr_alexaSubdomainContributions','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_insert_pdr_alexaSubdomainContributions
END
GO

CREATE PROC dbo.sp_insert_pdr_alexaSubdomainContributions
			@inputUrl					VARCHAR(900),
			@alexaUrl					VARCHAR(900),
			@subDomainUrl				VARCHAR(900),
			@reachPercent				DECIMAL (19,10),
			@pageViewsPercent			DECIMAL (19,10),
			@pageViewsPerUser			DECIMAL (19, 10),
			@insertStatus				BIT OUTPUT
AS
BEGIN
		INSERT INTO pdr_alexaContributingSubDomains
		(
			input_url,
			alexa_url,
			sub_domain_url,
			reach_percent,
			page_views_percent,
			page_views_per_user
		)
		VALUES
		(
			@inputUrl,
			@alexaUrl,
			@subDomainUrl,
			@reachPercent,
			@pageViewsPercent,
			@pageViewsPerUser
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO

IF OBJECT_ID(N'dbo.sp_insert_pdr_alexaUsageStatistics','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_insert_pdr_alexaUsageStatistics
END
GO

CREATE PROC dbo.sp_insert_pdr_alexaUsageStatistics
			@inputUrl					VARCHAR(900),
			@alexaUrl					VARCHAR(900),
			@timeUnitFlag				INT,
			@rank						BIGINT,
			@rankDelta					DECIMAL(19, 10),
			@reachPerMillion			DECIMAL(19, 10),
			@reachPerMillionDelta		DECIMAL(19, 10),
			@pageViewsPerMillion		DECIMAL(19, 10),
			@pageViewsPerMillionDelta	DECIMAL(19, 10),
			@pageViewsPerUser			DECIMAL(19, 10),
			@pageViewsPerUserDelta		DECIMAL(19, 10),
			@reachRank					INT,
			@reachRankDelta				DECIMAL(19, 10),
			@pageViewsRank				INT,
			@pageViewsRankDelta			DECIMAL(19, 10),
			@insertStatus				BIT OUTPUT
AS
BEGIN
		INSERT INTO pdr_alexaUsageStatistics
		(
			input_url,
			alexa_url,
			time_unit_flag,
			rank,
			rank_delta,
			reach_per_million,
			reach_per_million_delta,
			page_views_per_million,
			page_views_per_million_delta,
			page_views_per_user,
			page_views_per_user_delta,
			reach_rank,
			reach_rank_delta,
			page_views_rank,
			page_views_rank_delta
		)
		VALUES
		(
			@inputUrl,
			@alexaUrl,
			@timeUnitFlag,
			@rank,
			@rankDelta,
			@reachPerMillion,
			@reachPerMillionDelta,
			@pageViewsPerMillion,
			@pageViewsPerMillionDelta,
			@pageViewsPerUser,
			@pageViewsPerUserDelta,
			@reachRank,
			@reachRankDelta,
			@pageViewsRank,
			@pageViewsRankDelta
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 

END
GO


IF OBJECT_ID(N'dbo.sp_insert_pdr_alexaUrlLogs','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_insert_pdr_alexaUrlLogs
END
GO

CREATE PROC dbo.sp_insert_pdr_alexaUrlLogs
			@inputUrl					VARCHAR(900),
			@alexaUrl					VARCHAR(900),
			@flag						INT,
			@noOfRetriesToAlexa			INT,
			@roundTripTime				DECIMAL(19, 10),
			@responseParseTime			DECIMAL(19, 10),
			@queryPreparationTime		DECIMAL(19, 10),
			@databaseTxnTime			DECIMAL(19, 10),
			@modifiedTime				DATETIME,
			@insertStatus				BIT OUTPUT
AS
BEGIN
		INSERT INTO pdr_alexaUrlLogs
		(
				input_url,
				alexa_url,
				flag,
				no_of_retries_to_alexa,
				round_trip_time,
				response_parse_time,
				query_preparation_time,
				database_txn_time,
				modified_time,
				create_time
		)
		VALUES
		(
				@inputUrl,
				@alexaUrl,
				@flag,
				@noOfRetriesToAlexa,
				@roundTripTime,
				@responseParseTime,
				@queryPreparationTime,
				@databaseTxnTime,
				@modifiedTime,
				@modifiedTime
		)

		IF @@ERROR = 0 
		BEGIN
			SET @insertStatus = 1
		END 
END
GO


IF OBJECT_ID(N'dbo.sp_select_pdr_alexaUrlDetails','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_select_pdr_alexaUrlDetails
END
GO

CREATE PROC dbo.sp_select_pdr_alexaUrlDetails
			@inputUrls		TEXT
AS
BEGIN
               DECLARE @xml_hdl INT
                       EXEC sp_xml_preparedocument @xml_hdl OUTPUT, @inputUrls
                       DECLARE @TempList TABLE        (url VARCHAR(800))
                       INSERT INTO @TempList (url) (SELECT text FROM OPENXML(@xml_hdl,'/urls/url',2) WHERE text is not null);
                       
                       SELECT
							   aui.input_url,
                               aui.alexa_url,
                               aui.online_since,
                               aui.age,
                               aus.page_views_per_million,
                               aus.page_views_per_million_delta,
                               aus.page_views_per_user,
                               aus.page_views_per_user_delta,
                               aus.page_views_rank,
                               aus.page_views_rank_delta,
                               aus.rank,
                               aus.rank_delta,
                               aus.reach_per_million,
                               aus.reach_per_million_delta,
                               aus.reach_rank,
                               aus.reach_rank_delta,
                               aus.time_unit_flag
                       FROM
                       (
                               SELECT * FROM pdr_alexaUrlInfo AS ai, @Templist ri
                               
                               WHERE ai.input_url = ri.url
                       ) AS aui
                       LEFT OUTER JOIN
                       (
                               SELECT * FROM pdr_alexaUsageStatistics AS ast, @Templist ri
                               
                               WHERE ast.input_url = ri.url and time_unit_flag=1
                       ) AS aus
                       ON aui.alexa_url = aus.alexa_url
END
Go

IF OBJECT_ID(N'dbo.sp_select_pdr_logs_failureOnes','P') IS NOT NULL 
BEGIN
    DROP PROC dbo.sp_select_pdr_logs_failureOnes
END
GO
CREATE PROC dbo.sp_select_pdr_logs_failureOnes
       @id						varchar(50),
	   @processId1				int,
	   @processId2				int,
	   @processId3				int,
	   @topNLogs				int
AS
BEGIN     
	select top (@topNLogs) * from pdr_logs 
	where id like '%' + @id + '%' and (process_id = @processId1 or process_id = @processId2 or process_id = @processId3)
	order by log_time desc
END
GO