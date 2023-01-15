/*
Walmart
URL : https://datalemur.com/questions/histogram-users-purchases

Assume you are given the table on Walmart user transactions. Based on a user's most recent transaction date, write a query to obtain the users and the number of products bought.
Output the user's most recent transaction date, user ID and the number of products sorted by the transaction date in chronological order.


user_transactions Table:
Column Name	        Type
product_id	        integer
user_id	            integer
spend	            decimal
transaction_date	timestamp


user_transactions Example Input:
product_id	user_id	spend	transaction_date
3673	    123	68.90	    07/08/2022 12:00:00
9623	    123	274.10	    07/08/2022 12:00:00
1467	    115	19.90	    07/08/2022 12:00:00
2513	    159	25.00	    07/08/2022 12:00:00
1452	    159	74.50	    07/10/2022 12:00:00


Example Output:
transaction_date	    user_id	purchase_count
07/08/2022 12:00:00	    115	    1
07/08/2022 12:00:000	123	    2
07/10/2022 12:00:00	    159	    1

*/

SELECT T.transaction_date, T.user_id, T.purchase_count
FROM (
        SELECT transaction_date, user_id
          ,COUNT(DISTINCT product_id) as purchase_count, 
          RANK() OVER (PARTITION BY user_id ORDER BY transaction_date desc ) as rnk 
        FROM user_transactions
        GROUP BY transaction_date, user_id
        ORDER BY  user_id, transaction_date DESC
        ) T 
WHERE T.rnk = 1 
ORDER BY T.transaction_date,  T.purchase_count;