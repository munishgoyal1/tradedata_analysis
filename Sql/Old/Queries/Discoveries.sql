/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[AbsoluteUri]
      ,[DiscoveryStateID]
      ,[DiscoveryTypeID]
      ,[ExpectFileOrImage]
      ,[NumberOfTimesDiscovered]
  FROM [arachnode.net].[dbo].[Discoveries]
  
  order by NumberOfTimesDiscovered desc