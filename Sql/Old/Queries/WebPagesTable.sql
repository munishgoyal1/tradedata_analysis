/****** Script for SelectTopNRows command from SSMS  ******/
select COUNT(*)
  FROM [arachnode.net].[dbo].[WebPages]
  
  
--  delete t1
--from (select top (1) *
--        from [arachnode.net].[dbo].[WebPages]) t1