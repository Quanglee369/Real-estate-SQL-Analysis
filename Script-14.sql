-- DATA CLEANING

-- Break property name into smaller columns

with checks as(select property_name, 
                      case when property_name like '%BHK%' and property_name not like '%Builder%'  
                                                           and property_name not like '%BHK  %' then split_part(trim(property_name),' ',3)
                           when property_name like '%Builder%' then concat(split_part(trim(property_name),' ',3),' ', split_part(trim(property_name),' ',4))
                           when property_name like '%BHK  House%' then split_part(trim(property_name),' ',4)
                           else split_part(trim(property_name),' ',1)
                           end as property_type
from surathouse s)


select distinct property_type
from checks


alter table surathouse 
add property_type varchar,
add BHK numeric


update surathouse 
set property_type =   case when property_name like '%BHK%' and property_name not like '%Builder%'  
                                                           and property_name not like '%BHK  %' then split_part(trim(property_name),' ',3)
                           when property_name like '%Builder%' then concat(split_part(trim(property_name),' ',3),' ', split_part(trim(property_name),' ',4))
                           when property_name like '%BHK  House%' then split_part(trim(property_name),' ',4)
                           else split_part(trim(property_name),' ',1)
                           end,
    BHK = (case when property_name like '%BHK%' then split_part(trim(property_name),' ',1) end)::numeric 


    
--Check and clean both of the price columns, convert all price into rupee

select distinct case when price = 'Call for Price' then price
                     else split_part(price, ' ', 2)
                     end
from surathouse s 

select price_per_sqft, price, split_part(substring(price_per_sqft, 4),' ',1),    
	case when price = 'Call for Price' then price
	   	 when price like '%Cr' then replace((replace(split_part(substring(price, 4),' ',1),',', '')::numeric * 10000000)::varchar, '.0', '')
	   	 else replace((replace(split_part(substring(price, 4),' ',1),',', '')::numeric * 100000)::varchar,'.0', '')
	   	 end as price_c
from surathouse


alter table surathouse 
add price_per_sqft_c numeric,
add price_c VARCHAR


update surathouse
set price_per_sqft_c = case when replace(split_part(substring(price_per_sqft, 4),' ',1),',', '') = '' then null 
		                    else replace(split_part(substring(price_per_sqft, 4),' ',1),',', '')::numeric 
		                    end
		
update surathouse 
set price_c = 	case when price = 'Call for Price' then price
				   	 when price like '%Cr' then replace((replace(split_part(substring(price, 4),' ',1),',', '')::numeric * 10000000)::varchar, '.0', '')
				   	 else replace((replace(split_part(substring(price, 4),' ',1),',', '')::numeric * 100000)::varchar,'.0', '')
				   	 end 
				   	             

	   	 
-- Clear the wrong data in areawithtype column
	   	             
select areawithtype, count(areawithtype)
from surathouse s 
group by areawithtype 


delete from surathouse 
where areawithtype ='Status' or areawithtype ='Transaction'



-- Make a numeric square feet column

with checks as (select *, split_part(square_feet, ' ', 2) as unit
from surathouse s)
select distinct unit
from checks


select square_feet , 
	   case when square_feet like '%sqm' then replace(replace(square_feet, 'sqm', ''),',', '')::numeric * 107639 
	        when square_feet like '%sqyrd' then replace(replace(square_feet, 'sqyrd', ''),',', '')::numeric * 9 
	        when square_feet like '%ground' then replace(replace(square_feet, 'ground', ''),',', '')::numeric * 2400 
	        when square_feet like '%rood' then replace(replace(square_feet, 'rood', ''),',', '')::numeric * 10890 
	        when square_feet like '%acre' then replace(replace(square_feet, 'acre', ''),',', '')::numeric * 43560
	        else replace(replace(square_feet, 'sqft', ''),',', '')::numeric
	        end as square_feet_c
from surathouse


alter table surathouse 
add square_feet_c numeric


update surathouse 
set square_feet_c =  case when square_feet like '%sqm' then replace(replace(square_feet, 'sqm', ''),',', '')::numeric * 107639 
				          when square_feet like '%sqyrd' then replace(replace(square_feet, 'sqyrd', ''),',', '')::numeric * 9 
				          when square_feet like '%ground' then replace(replace(square_feet, 'ground', ''),',', '')::numeric * 2400 
				          when square_feet like '%rood' then replace(replace(square_feet, 'rood', ''),',', '')::numeric * 10890 
				          when square_feet like '%acre' then replace(replace(square_feet, 'acre', ''),',', '')::numeric * 43560
				          else replace(replace(square_feet, 'sqft', ''),',', '')::numeric
				          end

	        
	        
-- Handle the misalignment in transaction, status, facing, furnishing and floor columns   
     
select "transaction" , count("transaction")
from surathouse s
group by "transaction" 
order by count("transaction") desc

select "floor" , count("floor")
from surathouse s 
group by "floor" 
order by count("floor") desc

select facing  , count("facing")
from surathouse s 
group by "facing" 
order by count("facing") desc

select status  , count("status")-- This column doesn't have any misalignment
from surathouse s 
group by 1
order by count("status") desc

select furnishing  , count("furnishing")
from surathouse s 
group by "furnishing" 
order by count("furnishing") desc


select case when "transaction" in ('Unfurnished', 'Semi-Furnished', 'Furnished') then "transaction" 
	        when "floor" in ('Unfurnished', 'Semi-Furnished', 'Furnished') then "floor"
			when furnishing not in ('Unfurnished', 'Semi-Furnished', 'Furnished') then ''
			else furnishing 
			end as furnishing_c
from surathouse s 

select case when "status" similar to '%(out of)%' then "status"
            when "floor" not similar to '%(out of)%' then ''
	        else "floor" 
	        end as floor_c
from surathouse s 

select case when "status" similar to '%(Resale|New Property)%' then "status"
            when "floor"  similar to '%(Resale|New Property)%' then "floor"
	        when "transaction" not similar to '%(Resale|New Property)%' then ''
	        else "transaction"
	        end as transaction_c
from surathouse s


alter table surathouse 
add furnishing_c varchar,
add floor_c varchar,
add transaction_c varchar


update surathouse 
set furnishing_c = case when "transaction" in ('Unfurnished', 'Semi-Furnished', 'Furnished') then "transaction" 
				        when "floor" in ('Unfurnished', 'Semi-Furnished', 'Furnished') then "floor"
						when furnishing not in ('Unfurnished', 'Semi-Furnished', 'Furnished') then ''
						else furnishing 
						end

update surathouse 
set floor_c = case when "status" similar to '%(out of)%' then "status"
		           when "floor" not similar to '%(out of)%' then ''
			       else "floor" 
			       end
			
update surathouse 
set transaction_c = case when "status" similar to '%(Resale|New Property)%' then "status"
			             when "floor"  similar to '%(Resale|New Property)%' then "floor"
				         when "transaction" not similar to '%(Resale|New Property)%' then ''
				         else "transaction"
				         end



-- Handle null or blank data 

select price_per_sqft_c, price_c, square_feet_c 
from surathouse s 
where price_per_sqft_c is null


-- For the sake of simplicity, the remaining null data in price_per_sqft_c when price is "Call for Price" will be left as NULL

select price_c , square_feet_c, price_per_sqft_c,
  case when price_c <> 'Call for Price' and price_per_sqft_c is null and price_c::numeric / square_feet_c::numeric  < 1 then round(price_c::numeric / square_feet_c::numeric ,3)
       when price_c <> 'Call for Price' and price_per_sqft_c is null then ceil(price_c::numeric / square_feet_c::numeric) 
       when price_c = 'Call for Price' then price_per_sqft_c
       when price_c <> 'Call for Price' and price_c::numeric / square_feet_c::numeric  < 1 then round(price_c::numeric / square_feet_c::numeric ,3)
       else round(price_c::numeric / square_feet_c::numeric)
       end as calculation
from surathouse s

select case when furnishing_c ='' then 'Not specified' else furnishing_c end as non_null_furnishing,
       case when floor_c  ='' then 'Not specified' else floor_c end as non_null_floor,
       case when transaction_c ='' then 'Not specified' else transaction_c end as non_null_transaction
from surathouse s


update surathouse 
set price_per_sqft_c =  case when price_c <> 'Call for Price' and price_per_sqft_c is null and price_c::numeric / square_feet_c::numeric  < 1 then round(price_c::numeric / square_feet_c::numeric ,3)
						     when price_c <> 'Call for Price' and price_per_sqft_c is null then ceil(price_c::numeric / square_feet_c::numeric) 
						     when price_c = 'Call for Price' then price_per_sqft_c
						     when price_c <> 'Call for Price' and price_c::numeric / square_feet_c::numeric  < 1 then round(price_c::numeric / square_feet_c::numeric ,3)
						     else round(price_c::numeric / square_feet_c::numeric)
						     end
						       
update surathouse 
set furnishing_c = case when furnishing_c ='' then 'Not specified' else furnishing_c end,
    floor_c = case when floor_c  ='' then null else floor_c end,
    transaction_c = case when transaction_c ='' then 'Not specified' else transaction_c end

   
    
-- Break floor_c into smaller columns   
  
alter table surathouse 
add group_of_floors varchar
    
    
with checks as (select id, floor_c, 
       split_part(floor_c, 'out of', 1) as num_floor, 
       split_part(floor_c, 'out of', 2) as num_total_floor
from surathouse s)

,checks_1 as (select id, 
          case when num_floor similar to '%Ground%' then '0'
               when num_floor similar to '%Upper%' then '-1'
               when num_floor similar to '%Lower%' then '-2'
               when num_floor = '' then null
               else num_floor
               end
               from checks)

update surathouse 
set group_of_floors =  case when num_floor::numeric between -2 and -1 then 'Basement'
            when num_floor::numeric between 0 and 5 then '0-5'
            when num_floor::numeric between 6 and 10 then '6-10'
            when num_floor::numeric between 11 and 15 then '11-15'
            when num_floor::numeric between 16 and 20 then '16-20'
            else 'Others'
            end 
from checks_1 c_1
where surathouse.id = c_1.id

       
alter table surathouse 
add total_floor numeric


with checks as (select id, floor_c, 
       split_part(floor_c, 'out of', 1) as num_floor
from surathouse s )

update surathouse s
set 	
"floor" = case when num_floor similar to '%Ground%' then '0'
               when num_floor similar to '%Upper%' then '-1'
               when num_floor similar to '%Lower%' then '-2'
               when num_floor = '' then null
               else num_floor
               end
from checks c
where c.id = s.id                
      
               
update surathouse 
set total_floor = split_part(floor_c, 'out of', 2)::numeric 
 


-- Remove inapproriate data in status column and update status column
select status, count(*) 
from surathouse s 
group by 1


select status, 
       case when status similar to '%(X|Co-|out|New|Free|Resale|Power)%' then 'Not specified'
            when status similar to '%Poss.%' then 'Delay'
            else status
            end as status_c
from surathouse s


update surathouse 
set status = case when status similar to '%(X|Co-|out|New|Free|Resale|Power)%' then 'Not specified'
            when status similar to '%Poss.%' then 'Delay'
            else status
            end

            
            
-- Remove unuse column

alter table surathouse 
drop column floor_c,
drop column property_name,
drop column square_feet,
drop column "transaction",
drop column furnishing,
drop column facing,
drop column description,
drop column price,
drop column price_per_sqft



-- DATA CLEANING COMPLETED
 
-- CORRELATION CHECKS

-- General trend for floor and total_floor
-- Floor vs num_listed / average price
with checks as (select "floor", 
                       round(avg(price_per_sqft_c),1) as average_price, 
                       round(avg(square_feet_c),1) as average_square_feet,
                       count(*) num_listed
from surathouse s
group by 1)

select round(corr("floor"::numeric, average_price)::numeric, 1) as floor_vs_price, 
       round(corr("floor"::numeric, num_listed)::numeric, 1) as floor_vs_num_listed,
       round(corr(num_listed, average_square_feet)::numeric, 1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric, 1) as average_square_feet_vs_average_price
from checks

-- Total floor vs num_listed / average price
with checks as (select total_floor, 
                       round(avg(price_per_sqft_c),1) as average_price, 
                       round(avg(square_feet_c),1) as average_square_feet,
                       count(*) num_listed
from surathouse s
group by 1)

select round(corr(total_floor, average_price)::numeric, 1) as total_floor_vs_price, 
       round(corr(total_floor, num_listed)::numeric, 1) as total_floor_vs_num_listed,
       round(corr(num_listed, average_square_feet)::numeric, 1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric, 1) as average_square_feet_vs_average_price
from checks




-- Total floor vs other variable
-- Floor vs num_listed / average price of each area
with checks as (select areawithtype, 
                       "floor",
                       count(*) as num_listed, 
                       round(avg(price_per_sqft_c),1) as average_price,
                       round(avg(square_feet_c),1) as average_square_feet
from surathouse
where "floor" notnull 
group by 1,2)

select areawithtype, 
       round(corr("floor"::numeric, num_listed)::numeric, 1) as floor_vs_num_listed, 
       round(corr("floor"::numeric, average_price)::numeric, 1) as floor_vs_average_price,
       round(corr(num_listed, average_square_feet)::numeric, 1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric, 1) as average_square_feet_vs_average_price
from checks
group by areawithtype


-- Floor vs num_listed / average price of each area > each furnishing option
with checks as (select areawithtype, 
                       "floor", 
                       furnishing_c, 
                       count(*) as num_listed, 
                       round(avg(price_per_sqft_c),1) as average_price,
                       round(avg(square_feet_c),1) as average_square_feet
from surathouse
where "floor" notnull
group by 1,2,3
order by 1,3)

select areawithtype, 
       furnishing_c, 
       round(corr("floor"::numeric, num_listed)::numeric, 1) as floor_vs_num_listed, 
       round(corr("floor"::numeric, average_price)::numeric, 1) as floor_vs_average_price,
       round(corr(num_listed, average_square_feet)::numeric, 1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric, 1) as average_square_feet_vs_average_price
from checks
group by 1,2


--Floor vs num_listed / average price of each area > each status
with checks as (select areawithtype, 
                       "floor", 
                       status, 
                       count(*) as num_listed, 
                       round(avg(price_per_sqft_c),1) as average_price,
                       round(avg(square_feet_c),1) as average_square_feet
from surathouse
where "floor" notnull
group by 1,2,3
order by 1,3)

select areawithtype, 
       status, 
       round(corr("floor"::numeric, num_listed)::numeric, 1) as floor_vs_num_listed, 
       round(corr("floor"::numeric, average_price)::numeric, 1) as floor_vs_average_price,
       round(corr(num_listed, average_square_feet)::numeric, 1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric, 1) as average_square_feet_vs_average_price
from checks
group by 1,2


-- Floor vs num_listed / average price of each area > each transaction type
with checks as (select areawithtype, 
                       "floor", 
                       transaction_c, 
                       count(*) as num_listed, 
                       round(avg(price_per_sqft_c),1) as average_price,
                       round(avg(square_feet_c),1) as average_square_feet
from surathouse
where "floor" notnull
group by 1,2,3
order by 1,3)

select areawithtype, 
       transaction_c, 
       round(corr("floor"::numeric, num_listed)::numeric, 1) as floor_vs_num_listed, 
       round(corr("floor"::numeric, average_price)::numeric, 1) as floor_vs_average_price,
       round(corr(num_listed, average_square_feet)::numeric, 1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric, 1) as average_square_feet_vs_average_price
from checks
group by 1,2


-- Floor vs num_listed / average price of each area > each property type
	with checks as (select areawithtype, 
	                       "floor", 
	                       property_type, 
	                       count(*) as num_listed, 
	                       round(avg(price_per_sqft_c),1) as average_price,
	                       round(avg(square_feet_c),1) as average_square_feet
	from surathouse
	where "floor" notnull
	group by 1,2,3
	order by 1,3)
	
	select areawithtype, 
	       property_type, 
	       round(corr("floor"::numeric, num_listed)::numeric ,1) as floor_vs_num_listed, 
	       round(corr("floor"::numeric, average_price)::numeric,1) as floor_vs_average_price,
	       round(corr(num_listed, average_square_feet)::numeric,1) as average_square_feet_vs_num_listed,
	       round(corr(average_price, average_square_feet)::numeric,1) as average_square_feet_vs_average_price
	from checks
	group by 1,2



	
-- Total floor vs other variable
-- Total floor vs num_listed / average price each area
with checks as (select areawithtype, 
                       total_floor, 
                       count(*) as num_listed, 
                       round(avg(price_per_sqft_c),1) as average_price,
                       round(avg(square_feet_c),1) as average_square_feet
from surathouse
where total_floor notnull 
group by 1,2)

select areawithtype, 
       round(corr(total_floor, num_listed)::numeric,1) as total_floor_vs_num_listed, 
       round(corr(total_floor, average_price)::numeric,1) as total_floor_vs_average_price,
       round(corr(num_listed, average_square_feet)::numeric, 1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric, 1) as average_square_feet_vs_average_price
from checks
group by areawithtype


-- Total floor vs num_listed / average price each area > each furnishing option
with checks as (select areawithtype, 
                       total_floor, 
                       furnishing_c, 
                       count(*) as num_listed, 
                       round(avg(price_per_sqft_c),1) as average_price,
                       round(avg(square_feet_c),1) as average_square_feet
from surathouse
where total_floor notnull
group by 1,2,3
order by 1,3)

select areawithtype, 
       furnishing_c, 
       round(corr(total_floor, num_listed)::numeric ,1) as total_floor_vs_num_listed, 
       round(corr(total_floor, average_price)::numeric,1) as total_floor_vs_average_price,
       round(corr(num_listed, average_square_feet)::numeric,1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric,1) as average_square_feet_vs_average_price
from checks
group by 1,2


-- Total floor vs num_listed / average price each area > each status
with checks as (select areawithtype, 
                       total_floor, 
                       status, 
                       count(*) as num_listed, 
                       round(avg(price_per_sqft_c),1) as average_price,
                       round(avg(square_feet_c),1) as average_square_feet
from surathouse
where total_floor notnull
group by 1,2,3
order by 1,3)

select areawithtype, 
       status, 
       round(corr(total_floor, num_listed)::numeric ,1) as total_floor_vs_num_listed, 
       round(corr(total_floor, average_price)::numeric,1) as total_floor_vs_average_price,
       round(corr(num_listed, average_square_feet)::numeric,1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric,1) as average_square_feet_vs_average_price
from checks
group by 1,2


-- Total floor vs num_listed / average price each area > each transaction type
with checks as (select areawithtype, 
                       total_floor, 
                       transaction_c, 
                       count(*) as num_listed, 
                       round(avg(price_per_sqft_c),1) as average_price,
                       round(avg(square_feet_c),1) as average_square_feet
from surathouse
where total_floor notnull
group by 1,2,3
order by 1,3)

select areawithtype, 
       transaction_c, 
       round(corr(total_floor, num_listed)::numeric ,1) as total_floor_vs_num_listed, 
       round(corr(total_floor, average_price)::numeric,1) as total_floor_vs_average_price,
       round(corr(num_listed, average_square_feet)::numeric,1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric,1) as average_square_feet_vs_average_price
from checks
group by 1,2


-- Total floor vs num_listed / average price each area > each property type
with checks as (select areawithtype, 
                       total_floor, 
                       property_type, 
                       count(*) as num_listed, 
                       round(avg(price_per_sqft_c),1) as average_price,
                       round(avg(square_feet_c),1) as average_square_feet
from surathouse
where total_floor notnull
group by 1,2,3
order by 1,3)

select areawithtype, 
       property_type, 
       round(corr(total_floor, num_listed)::numeric ,1) as total_floor_vs_num_listed, 
       round(corr(total_floor, average_price)::numeric,1) as total_floor_vs_average_price,
       round(corr(num_listed, average_square_feet)::numeric,1) as average_square_feet_vs_num_listed,
       round(corr(average_price, average_square_feet)::numeric,1) as average_square_feet_vs_average_price
from checks
group by 1,2


-- AVERAGE PRICE AND NUMBER LISTED CHECKS

-- Average price, num_listed of areawithtype
select areawithtype, 
       round(avg(price_per_sqft_c),1) as average_price, 
       count(*) as num_listed
from surathouse s
group by 1


-- Transaction type
-- Average price, num_listed of each transaction type
select transaction_c, 
       round(avg(price_per_sqft_c),1) as average_price, 
       count(*) as num_listed
from surathouse s
group by 1


-- Average price, num_listed of areawithtype > transaction type
select areawithtype, transaction_c, 
       count(*) as num_listed, 
       round(avg(price_per_sqft_c),1) as average_price
from surathouse s 
group by 1,2
order by 1,2




-- Furnishing options
-- Average price, num_listed of furnishing options
select furnishing_c, 
       round(avg(price_per_sqft_c),1) as average_price, 
       count(*) as num_listed
from surathouse s
group by 1


-- Average price, sales of areawithtype > furnishing options
select areawithtype, furnishing_c, 
       count(*) as num_listed, 
       round(avg(price_per_sqft_c),1) as average_price
from surathouse s 
group by 1,2
order by 1,2



-- Status
-- Average price, num_listed of status
select status, 
       round(avg(price_per_sqft_c),1) as average_price, 
       count(*) as num_listed
from surathouse s
group by 1	


-- Average price, num_listed of areawithtype > status
select areawithtype, status, 
       count(*) as num_listed, 
       round(avg(price_per_sqft_c),1) as average_price
from surathouse s 
group by 1,2
order by 1,2



-- Property type
-- Average price, num_listed of property type 
select property_type , 
       round(avg(price_per_sqft_c),1) as average_price, 
       count(*) as num_listed
from surathouse s 
group by 1
order by 1


-- Average price, num_listed of areawithtype > property type 
select areawithtype, property_type , 
       round(avg(price_per_sqft_c),1) as average_price, 
       count(*) as num_listed
from surathouse s 
group by 1,2
order by 1,2

