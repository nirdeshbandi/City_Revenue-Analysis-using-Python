--creating table 
	create table city_revenue(
		Fiscal_Year numeric,
		Record_Key text,
		purpose text,
		County_Code text,
		County text,
		GNIS_Feature_ID numeric,
		City_Code text,
		City_Name text,
		Revenue_Type text,
		Budget numeric,
		Actual numeric,
		Primary_Coordinates text,
		logitude numeric,
		latitude numeric
)

--Retrieveing all records from table
	select * from city_revenue  

--Total no.of functions in table 
	select count(*) from city_revenue  --215280

--Standarzing the columns in table
	update city_revenue set county_code = lower(county_code) 
	update city_revenue set city_name = lower(city_name)
	update city_revenue set primary_coordinates = lower(primary_coordinates)

--Finding average actual_revenue per years
	select fiscal_year,purpose,round(avg(actual))as actual_revenue,round(avg(budget))as budget from city_revenue
	where actual is not null 
	group by fiscal_year,purpose 
	order by fiscal_year desc

--Finding the profit per years
	select fiscal_year,county,city_name,purpose,actual-budget as profit from city_revenue 
	where actual is not null 
	group by fiscal_year,county,city_name,purpose,profit 
	order by fiscal_year desc

--Identifying Total_budget, Total_revenue, Total_profit per year
	select fiscal_year,sum(budget)as total_budget,sum(actual)as total_revenue,sum(actual-budget)as total_profit from city_revenue 
	where actual is not null 
	group by fiscal_year 
	order by fiscal_year desc

--Identifying Total_budget, Total_revenue, Total_profit per country,city and year
	select fiscal_year,county,city_name,sum(budget)as total_budget,sum(actual)as total_revenue,sum(actual-budget)as total_profit from city_revenue 
	where actual is not null 
	group by fiscal_year,county,city_name 
	order by fiscal_year desc

--Identifying country,city,fiscal_year which are greater than average budget
	select fiscal_year,county,city_name,sum(budget)as total_budget,sum(actual)as total_revenue,sum(actual-budget)as total_profit from city_revenue 
	where actual is not null 
	group by fiscal_year,county,city_name 
	having sum(budget) > 600000 
	order by fiscal_year desc 

--Identifying fiscal_year which are greater than average budget using CTE
	with avg_city as(
		select fiscal_year,round(avg(budget)) as total_revenue from city_revenue
		where fiscal_year is not null
		group by fiscal_year 
	) 
	select fiscal_year,total_revenue from avg_city
	where total_revenue > 600000
	group by fiscal_year,total_revenue
	order by fiscal_year desc

--assigning rank to the top year
	with avg_city as(
		select fiscal_year,round(avg(budget)) as avg_budget,county,dense_rank() over(order by fiscal_year desc) from city_revenue
 		where fiscal_year is not null group by county,city_name,fiscal_year

	)
	select dense_rank,fiscal_year,avg_budget,county from avg_city
 	where avg_budget > 200000































































