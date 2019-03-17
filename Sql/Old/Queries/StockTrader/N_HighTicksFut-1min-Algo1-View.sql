IF OBJECT_ID(N'dbo.FN_HIGH_TICKS_FUT_RECORDS','FN') IS NOT NULL 
BEGIN
	DROP function dbo.FN_HIGH_TICKS_FUT_RECORDS
END
GO

create function dbo.FN_HIGH_TICKS_FUT_RECORDS
(
    --@contract_name					varchar(100),
	--@r1								varchar(100),
	@r2								varchar(100),
	--@market_direction_percentage	decimal(12, 2),
	@algo_id						smallint,
    @ticks_per_day					int
)

returns table as return

select  distinct  number_of_ticks
			, num_days, 
			number_of_ticks/num_days as ticksperday, 
			contract_name, 
			start_date, 
			end_date 

			from st_trading_eop_statsbook

			where r2 = @r2
			--and r1 = '2006'
			and algo_id = @algo_id
			and number_of_ticks/num_days >= @ticks_per_day
			
			--end dbo.FN_HIGH_TICKS_FUT_RECORDS;
			
			
			create view FN_HIGH_TICKS_FUT_RECORDS_STOCKNAME
			as
			select distinct highfutick.contract_name from
			(
				select  distinct top(10000) number_of_ticks
				, num_days, number_of_ticks/num_days as ticksperday, 
				contract_name, 
				start_date, 
				end_date 

				from st_trading_eop_statsbook

				where r2 = 'IEOD-1min'
				--and r1 = '2006'
				and algo_id = 1
				and number_of_ticks/num_days > 300
				--order by ticksperday desc
				--order by number_of_ticks desc
				--order by contract_name asc
			) as highfutick
			
			
			create function dbo.FN_HIGH_TICKS_FUT_N_RANDOM_STOCKS
			(
				@numStocks						int
			)
			returns table as return
			select top(@numStocks) hh.contract_name from
			(
				select   distinct highfutick.contract_name from
				(
					select  distinct  number_of_ticks
					, num_days, number_of_ticks/num_days as ticksperday, 
					contract_name, 
					start_date, 
					end_date 

					from st_trading_eop_statsbook

					where r2 = 'IEOD-1min'
					--and r1 = '2006'
					and algo_id = 1
					and number_of_ticks/num_days > 300
					--order by ticksperday desc
					--order by number_of_ticks desc
					--order by contract_name asc
					
				)  as highfutick 
			) as hh
			order by newid()
			 
			 drop view VW_HIGH_TICKS_FUT_5_RANDOM_STOCKS
			 create view VW_HIGH_TICKS_FUT_5_RANDOM_STOCKS
			as
			 select top(5) hh.contract_name  from
			(
				select   distinct highfutick.contract_name from
				(
					select  distinct  number_of_ticks
					, num_days, number_of_ticks/num_days as ticksperday, 
					contract_name, 
					start_date, 
					end_date 

					from st_trading_eop_statsbook

					where r2 = 'IEOD-1min'
					--and r1 = '2006'
					and algo_id = 1
					and number_of_ticks/num_days > 300
					--order by ticksperday desc
					--order by number_of_ticks desc
					--order by contract_name asc
					
				)  as highfutick 
			) as hh
			order by newid()
			 
			 
			 drop function FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS
			 create function FN_HIGH_TICKS_FUT_5_RANDOM_STOCKS()
			 returns table as return
			 SELECT * FROM VW_HIGH_TICKS_FUT_5_RANDOM_STOCKS
			 
--			 create view getNewID as select newid() as new_id

--create function myfunction ()
--returns uniqueidentifier
--as begin
--   return (select new_id from getNewID)
--end