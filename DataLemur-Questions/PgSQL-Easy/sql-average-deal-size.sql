/*
Easy

Salesforce
Assume that Salesforce customers pay on a per user basis (also referred to as per seat model). Given a table of contracts data, write a query to calculate the average annual revenue per Salesforce customer. Round your answer to 2 decimal places.

Assume each customer only has 1 contract and the yearly seat cost refers to cost per seat.

contracts Table:
Column Name	Type
customer_id	integer
num_seats	integer
yearly_seat_cost	integer
contracts Example Input:
customer_id	num_seats	yearly_seat_cost
2690	    20	        1000
2561	    50	        500
4520	    100	        500
9875	    40	        1000
5260	    150	        100
Example Output:
average_deal_size
30000.00

*/
SELECT 
  ROUND(SUM((num_seats*yearly_seat_cost))::numeric/ COUNT(customer_id)::numeric,2) average_deal_size 
FROM contracts;