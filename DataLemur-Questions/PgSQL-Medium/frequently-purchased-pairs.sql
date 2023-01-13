/*
Walmart

Assume you are given the following tables on Walmart transactions and products. Find the number of unique product combinations that are bought together (purchased in the same transaction).

For example, if I find two transactions where apples and bananas are bought, and another transaction where bananas and soy milk are bought,
my output would be 2 to represent the 2 unique combinations. Your output should be a single number.

Assumption:
    For each transaction, a maximum of 2 products is purchased.


transactions Table:
Column Name	        Type
transaction_id	    integer
product_id	        integer
user_id	            integer
transaction_date	datetime


transactions Example Input:
transaction_id	product_id	user_id	transaction_date
231574	        111	        234	    03/01/2022 12:00:00
231574	        444	        234	    03/01/2022 12:00:00
231574	        222	        234	    03/01/2022 12:00:00
137124	        111	        125 	03/05/2022 12:00:00
137124	        444	        125	    03/05/2022 12:00:00


products Table:
Column Name	    Type
product_id	    integer
product_name	string


products Example Input:
product_id	product_name
111	        apple
222	        soy milk
333	        instant oatmeal
444	        banana
555	        chia seed


Example Output:
combo_num
4
There are 4 unique purchase combinations present in the example data.

                       
*/
--  Using combination formula: nC2 = n! / 2! * (n-2)!

WITH combination_total
    AS (SELECT T.*,
                ROUND(FACTORIAL(T.total_) / ( FACTORIAL(2) * FACTORIAL(T.total_ - 2) )
                ) AS
                  combinations
        FROM   (SELECT transaction_id, transaction_date
                  ,COUNT(product_id) AS total_
        FROM   transactions WHERE product_id IN (SELECT DISTINCT product_id FROM products )
        GROUP  BY transaction_id, transaction_date
        HAVING COUNT(product_id) >= 2
        ORDER  BY transaction_id, transaction_date) T)
SELECT SUM(combinations) combo_num
FROM   combination_total; 

-- Result:
--  6

-- Check Cases:
SELECT DISTINCT T.transaction_id,T.A_product, T.B_product
FROM
(
  SELECT DISTINCT
    A.transaction_id , A.product_id AS  A_product,
    B.product_id AS B_product
  FROM transactions A
  JOIN transactions B
    ON A.transaction_id = B.transaction_id
    AND A.product_id IN (SELECT DISTINCT product_id FROM products ) 
  WHERE  A.product_id > B.product_id
) T
ORDER BY T.transaction_id DESC
;

-- Return:
-- transaction_id	a_product	b_product
-- 523152	        444	        222
-- 256234	        333	        222
-- 231574	        444	        222
-- 231574	        222     	111
-- 231574	        444	        111
-- 137124	        444	        111
