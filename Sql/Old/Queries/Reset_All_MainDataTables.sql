BEGIN TRAN

/****** Script for SelectTopNRows command from SSMS  ******/
delete
  FROM [arachnode.net].[dbo].[Discoveries]
  
  delete
  FROM [arachnode.net].[dbo].[HyperLinks_Discoveries]
  
  delete
  FROM [arachnode.net].[dbo].[HyperLinks]
  
  delete
  FROM [arachnode.net].[dbo].[WebPages]
  
  
  delete
  FROM [arachnode.net].[dbo].[Exceptions]
  
  
  delete
  FROM [arachnode.net].[dbo].[DisallowedAbsoluteUris]
  
  delete
  FROM [arachnode.net].[dbo].[CrawlRequests]
  

ROLLBACK