/*
Wayfair
URL: https://datalemur.com/questions/yoy-growth-rate
Assume you are given the table below containing information on user transactions for particular products. Write a query to obtain the year-on-year growth rate for the total spend of each product for each year.
Output the year (in ascending order) partitioned by product id, current year's spend, previous year's spend and year-on-year growth rate (percentage rounded to 2 decimal places).

user_transactions Table:
Column Name	        Type
transaction_id	    integer
product_id	        integer
spend	            decimal
transaction_date	datetime


user_transactions Example Input:
transaction_id	product_id	spend	transaction_date
1341	        123424	    1500.60	12/31/2019 12:00:00
1423	        123424	    1000.20	12/31/2020 12:00:00
1623	        123424	    1246.44	12/31/2021 12:00:00
1322	        123424	    2145.32	12/31/2022 12:00:00


Example Output:
year	product_id	curr_year_spend	prev_year_spend	yoy_rate
2019	123424	    1500.60		
2020	123424	    1000.20	        1500.60	-33.35
2021	123424	    1246.44	        1000.20	24.62
2022	123424	    2145.32	        1246.44	72.12

The third row in the example output shows that the spend for product 123424 grew 24.62% from 1000.20 in 2020 to 1246.44 in 2021.
*/

SELECT 
   T.year
  ,T.product_id
  ,T.curr_year_spend
  ,T.prev_year_spend
  ,ROUND(100.0*((T.curr_year_spend/T.prev_year_spend)-1),2) yoy_rate
FROM
(SELECT 
  EXTRACT(YEAR FROM transaction_date) AS "year"
  ,product_id
  ,SUM(spend) curr_year_spend 
  ,LAG(SUM(spend)) OVER(PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date) ASC) prev_year_spend
FROM user_transactions
GROUP BY EXTRACT(YEAR FROM transaction_date), product_id) T
ORDER BY product_id, year
;