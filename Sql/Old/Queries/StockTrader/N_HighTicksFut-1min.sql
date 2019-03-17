-- #1

--select distinct highfutick.contract_name from
--(
--		select  distinct top(10000) number_of_ticks
--		, num_days, number_of_ticks/num_days as ticksperday, 
--		contract_name, 
--		start_date, 
--		end_date 

--		from st_trading_eop_statsbook

--		where r2 = 'IEOD-1min'
--		--and r1 = '2006'
--		and algo_id = 1
--		and number_of_ticks/num_days > 300
--		--order by ticksperday desc
--		--order by number_of_ticks desc
--		--order by contract_name asc
--) as highfutick

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



-- #2

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




-- #3


--select  distinct  contract_name 

--from st_trading_eop_statsbook

--where r2 = 'IEOD-1min'
----and r1 = '2006'
--and algo_id = 1
--order by contract_name asc
----order by ticksperday desc
