-- loaded the dataset into database named credit_card
-- checking the number of rows 
select count(*) FROM credit_card.credit_card_transactions;
select * FROM credit_card_transactions;

-- checking the data types 
describe credit_card_transactions;

-- To modify the datatypes of columns , we need to set the sql safe update to false
SET SQL_SAFE_UPDATES = 0;

-- change the data type of date column to date from string 
update credit_card_transactions
set date = str_to_date(date, "%d-%m-%Y");

-- modifying the datatypes 
alter table credit_card_transactions
modify column  date date;

alter table credit_card_transactions
modify column  time TIME;

alter table credit_card_transactions
modify column  Gender Varchar(100);

alter table credit_card_transactions
modify column  City varchar(100);

-- changing the column names
alter table credit_card_transactions
change column `card type` card_type varchar(100); 

alter table credit_card_transactions
change column `Exp Type` exp_type varchar(100);


alter table credit_card_transactions
change column date transaction_date date;

-- dropping unnecessary columns
alter table credit_card_transactions
drop column `index`;

select * from credit_card_transactions;


-- check whether the table has any null / missing values 
-- cheked for all columns and no null values present
select * from credit_card_transactions
where amount is null;


-- Who does the most no of transactions (Males or Females) ?
select gender,count(*) as no_of_transactions from credit_card_transactions
group by  gender;

-- Which card type is highly and least used ?
with cte as (
select *, 
dense_rank() over(order by no_of_times_used desc ) as rn from (
select card_type, count(*) as no_of_times_used from credit_card_transactions
group by card_type ) x )

select card_type , no_of_times_used, 
case when rn=1 then "Most no of times used" else "Least no of times used" end as `Frequency type` from cte 
where rn =1 
or rn = (select max(rn) from cte)
;


-- 3 City having lowest number of transactions ?
with cte as (
select *, dense_rank() over(order by no_of_transactions ) as rn  from (
select city, count(transaction_date) as no_of_transactions from credit_card_transactions
group by city ) x )

select city, no_of_transactions from cte 
where rn in (1,2,3)
order by rn ;



-- Top 3 cities having the most number of transactions ?
with cte as (
select *, dense_rank() over(order by no_of_transactions desc ) as rn  from (
select city, count(transaction_date) as no_of_transactions from credit_card_transactions
group by city ) x )

select city, no_of_transactions from cte 
where rn in (1,2,3)
order by rn ;



-- What is the average transaction value during weekends and weekdays in each card type?
select * from credit_card_transactions;
with cte as (
select card_type, round(avg(amount), 2) as avg_weekend_trans_value
 from (select * from credit_card_transactions where  date_format(transaction_date, "%a") in ("sat", "sun")  ) x
group by card_type )
, cte2 as (
select card_type,  round(avg(amount), 2) as avg_weekday_trans_value
 from (select * from credit_card_transactions where  date_format(transaction_date, "%a") not in ("sat", "sun") ) y
group by card_type)

select cte.card_type, cte.avg_weekend_trans_value, cte2.avg_weekday_trans_value
from cte join cte2 on cte.card_type=cte2.card_type;

-- In which expense category does the most and least number of transactions happen ?
with cte as (
select exp_type, count(transaction_date) as no_of_transactions from credit_card_transactions
group by exp_type ),

cte2 as (
select *, 
DENSE_RANK() over(order by no_of_transactions asc) as rn_asc, 
DENSE_RANK() over(order by no_of_transactions desc) as rn_desc from cte )

, cte3 as (
select exp_type, no_of_transactions, rn_asc, rn_desc from cte2
where rn_asc=1 or rn_desc=1 )

select exp_type, no_of_transactions,
case when rn_desc=1 then "Most Number of Transactions"
when rn_asc=1 then "Least Number of Transactions" end as Frequency
from cte3;
-- Which exp type dominates most of the subcategories of Card Type ?
with cte as (
select * from (
select card_type,exp_type, count(transaction_date) over(partition by card_type,exp_type ) as cnt
from credit_card_transactions ) x
group by  card_type,exp_type , cnt
order by card_type,exp_type )
, cte2 as (
select *, 
dense_rank() over(partition by card_type order by cnt desc) as rn_desc, 
dense_rank() over(partition by card_type order by cnt ) as rn_asc
from cte )

select a.card_type, a.exp_type as most_no_of_transactions_expensive_category, 
b.exp_type as least_no_of_transactions_expensive_category from 
(select card_type, exp_type , cnt from cte2 where rn_desc=1 ) a join 
(select card_type, exp_type, cnt from cte2 where rn_asc=1) b
on a.card_type=b.card_type;


-- Which card type has the highest & least contribution to total amount ?

select * from credit_card_transactions;
select card_type, round((amount*1.0/total_amount)*100, 3) as contribution_percent from (
select *
from (select card_type, sum(amount) as amount from credit_card_transactions group by card_type) a , 
(select sum(amount) as total_amount from credit_card_transactions) b ) x 
order by round((amount*1.0/total_amount)*100, 3) desc;


-- Which Expense Type has the highest & lowest contribution to the total amount ?
select exp_type, round((amount*1.0/total_amount)*100, 3) as contribution_percent from (
select *
from (select exp_type, sum(amount) as amount from credit_card_transactions group by exp_type) a , 
(select sum(amount) as total_amount from credit_card_transactions) b ) x 
order by round((amount*1.0/total_amount)*100, 3) desc;


-- Which Gender Type has the highest & lowest contribution to the total amount ?
select gender, round((amount*1.0/total_amount)*100, 3) as contribution_percent from 
(
select * from 
(select gender, sum(amount) as amount from credit_card_transactions group by gender) a , 
(select sum(amount) as total_amount from credit_card_transactions) b 
) x 
order by round((amount*1.0/total_amount)*100, 3) desc;


-- contribution percentage number of males and females in each card type with respect to total number of transactions
with cte as (
select * from (
select card_type, gender, count(transaction_date) as count_of_trans  
from credit_card_transactions
group by card_type, gender
order by card_type, gender) a , (select count(*) as total_count_of_trans from credit_card_transactions ) b )

select card_type, gender, round((count_of_trans*1.0/total_count_of_trans) *100, 2) as contribution_percentage
from cte ;


-- during weekends which city has the highest total spend to total no of transcations ratio
select * from credit_card_transactions;
select city, round((sum(amount)*1.0/count(*))*100) as ratio
from credit_card_transactions
where date_format(transaction_date, "%W") in ( "Sunday", "Saturday")
group by city
order by round((sum(amount)*1.0/count(*))*100, 2) desc
limit 1;


-- write a query to print 3 columns: city, highest_expense_type , lowest_expense_type 
with cte as (
select city, exp_type, sum(amount) as amount  from credit_card_transactions
group by city, exp_type order by city, exp_type )
, cte2 as (
select *, 
dense_rank() over(partition by city order by amount desc) as rn_desc, 
dense_rank() over(partition by city order by amount ) as rn_asc
from cte )

select a.city, a.exp_type as highest_expense_type, b.exp_type as lowest_expense_type from 
(select city, exp_type from cte2 where rn_desc=1 ) a join
(select city, exp_type from cte2 where rn_asc=1) b
on a.city=b.city;
-- Write a query to find city which had the lowest percentage spent for gold card type

select * from credit_card_transactions;
select city from (
select city, sum(amount) as amount
from credit_card_transactions
where card_type = "Gold"
group by city) a , (select sum(amount) as total_amount from credit_card_transactions) b 
order by (amount*1.0/total_amount)*100 
limit 1 ; 

-- Which card and expense type combination saw the highest month over month growth in Jan-2014 ?
with cte as (
select * from credit_card_transactions
where transaction_date between "2013-12-01" and "2014-01-31"
order by transaction_date )
, cte2 as (
select * from (
select *, lead(amount, 1) over(partition by card_type, exp_type order by name_of_month desc ) as jan_amount from (
select card_type, exp_type, date_format(transaction_date, "%m") as name_of_month , sum(amount) as amount 
from cte
group by card_type, exp_type, date_format(transaction_date, "%m") ) x ) y 
where jan_amount is not null )

select card_type, exp_type, ((jan_amount*1.0/amount) - 1 ) *100 as MoM_Growth_Rate from cte2 
order by ((jan_amount*1.0/amount) - 1 ) desc
limit 1;


-- Write a query to print the highest spend month and amount spent in that month for each card type.

select * from credit_card_transactions;
with cte as (
select *, 
max(amount)  over(partition by card_type ) as max_amount from (
select card_type, date_format(transaction_date, "%Y-%m") as `year_month`, 
sum(amount) as amount
from credit_card_transactions
group by card_type, date_format(transaction_date, "%Y-%m")  ) x )

select card_type,`year_month`, max_amount from cte 
where max_amount=amount;


/* Write a query to print top 5 cities with highest spends and their percentage contribution to total credit card 
spends and further within each city, find the percentage contribution of different card types. */
with cte1 as (
with cte as ( select city ,amount, round((amount*1.0/ total_amount) *100, 8) as contribution_percentage from 
(select city, sum(amount) as amount from credit_card_transactions
group by city) a, (select sum(amount) as total_amount 
from credit_card_transactions ) b ) 
select city,amount, contribution_percentage from (
select city,amount, contribution_percentage, 
dense_rank() over(order by contribution_percentage desc) as rn from cte ) x where rn<=5 )

,cte2 as (select city, card_type, round(
((sum(Amount) over(partition by city, card_type))  *1.0/ 
(sum(amount) over(partition by city)))*100, 8) as contribution_percentage_of_card from (
select city, card_type, sum(Amount) as amount from credit_card_transactions group by city, card_type ) x ) 

select cte1.city,cte1.amount, cte1.contribution_percentage, 
cte2.card_type, cte2.contribution_percentage_of_card
from cte1 join cte2 on cte1.city=cte2.city;

-- Which city took the least number of days to reach its 500th transaction after the first transaction in that city ?

with cte as (
select city, count(*) as no_of_transactions, min(transaction_date) as min_transaction_date, 
max(transaction_date) as max_transaction_date
from credit_card_transactions group by city having  count(*)>=500 )

, cte2 as (
select *, count(*) over(partition by city order by transaction_date, time) as no_of_trans_in_city 
from credit_card_transactions) 

, cte3 as (
select cte.city,cte.no_of_transactions,cte.min_transaction_date, cte.max_transaction_date ,cte2.transaction_date, 
cte2.time ,cte2.no_of_trans_in_city
from cte join cte2 on cte.city=cte2.city )

, cte4 as (
select city,min_transaction_date,max_transaction_date ,transaction_date, 
min(days_diff) as min_days_taken_to_500th_transaction from 
(select city,min_transaction_date,max_transaction_date,transaction_date,
timestampdiff(day, min_transaction_date, transaction_date) as days_diff, no_of_trans_in_city from 
(select * from cte3 where no_of_trans_in_city=500 ) x ) y 
group by city,min_transaction_date,max_transaction_date,transaction_date ) 

select city, min_transaction_date,transaction_date as 500th_transaction_date, 
min_days_taken_to_500th_transaction as days_taken_to_500th_transaction from 
(select *,dense_rank() over(order by min_days_taken_to_500th_transaction ) as rn from cte4 ) z
where rn=1 ;



/* Write a query to print the transaction details for each card type when it reaches a 
cumulative of 10,00,000 total spends */
select * from credit_card_transactions;
select city, transaction_date, time, transactionid,card_type, exp_type,gender, amount, cumulative_total from 
(select *, first_value(cumulative_total) 
over(partition by card_type  order by transaction_date, time rows between unbounded preceding and unbounded following) 
as transaction_reaching_cum_1000000 from 
(select *, sum(amount) over(partition by card_type order by transaction_date, time) as cumulative_total
from credit_card_transactions )  x
where cumulative_total>=1000000 ) y 
where transaction_reaching_cum_1000000=cumulative_total;

