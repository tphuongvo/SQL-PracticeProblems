/*
Assume you are given the table below containing information on user transactions on Stripe. Write a query to obtain all of the users' rolling 3-day earnings. Output the user ID, transaction date and rolling 3-day earnings.

Assumption:

The user_transactions table is complete and there are no missing days in between.
Each row in the user_transactions table represents one day.

user_transactions Table:
Column Name	Type
transaction_id	    integer
user_id	            integer
amount	            decimal
transaction_date	datetime

user_transactions Example Input:
transaction_id	user_id	amount	transaction_date
1354	        423	240.13	    01/01/2022 12:00:00
1223	        525	124.20	    01/01/2022 12:00:00
1732	        525	324.00	    01/02/2022 12:00:00
1352	        423	234.14	    01/02/2022 12:00:00
1141	        525	123.00	    01/03/2022 12:00:00

Example Output:
user_id	transaction_date	rolling_earnings_3d
    423	01/01/2022 12:00:00	240.13
    423	01/03/2022 12:00:00	474.27
    525	01/01/2022 12:00:00	124.20
    525	01/02/2022 12:00:00	448.20
    525	01/03/2022 12:00:00	571.20
User 525's rolling 3-day earning of 571.20 is a cumulative total of the 2 previous days (124.20 + 324.00) and current day (123.00).
*/

WITH daily_transactions AS (
  SELECT
    user_id
    ,transaction_date
    ,SUM(amount) AS total_earnings
FROM user_transactions
GROUP BY user_id, transaction_date
)

SELECT
  user_id
  ,transaction_date
  -- ,total_earnings
  ,SUM(total_earnings) OVER (PARTITION BY user_id ORDER BY transaction_date
        RANGE BETWEEN INTERVAL '2 days' PRECEDING AND CURRENT ROW) AS rolling_3d_earnings
-- ,SUM(total_earnings) OVER (PARTITION BY user_id ORDER BY transaction_date
--         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3d_earnings_rows
FROM daily_transactions

;