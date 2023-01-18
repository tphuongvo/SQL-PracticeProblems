/*
Amazon
URL: https://datalemur.com/questions/prime-warehouse-storage
Amazon wants to maximize the number of items it can stock in a 500,000 square feet warehouse. 
It wants to stock as many prime items as possible, and afterwards use the remaining square footage to stock the most number of non-prime items.

Write a SQL query to find the number of prime and non-prime items that can be stored in the 500,000 square feet warehouse. Output the item type and number of items to be stocked.

inventory table:
Column Name	    Type
item_id	        integer
item_type	    string
item_category	string
square_footage	decimal


inventory Example Input:
item_id	item_type	    item_category	square_footage
1374	prime_eligible	mini refrigerator	68.00
4245	not_prime	    standing lamp	26.40
2452	prime_eligible	television	85.00
3255	not_prime	    side table	22.60
1672	prime_eligible	laptop	8.50


Example Output:
item_type	    item_count
prime_eligible	9285
not_prime	    6

To prioritise storage of prime_eligible items:
The combination of the prime_eligible items has a total square footage of 161.50 sq ft (68.00 sq ft + 85.00 sq ft + 8.50 sq ft).
To prioritise the storage of the prime_eligible items, we find the number of times that we can stock the combination of the prime_eligible items which are 3,095 times, mathematically expressed as:
                    500,000 sq ft / 161.50 sq ft = 3,095 items      
Then, we multiply 3,095 times with 3 items (because we're asked to output the number of items to stock), which gives us 9,285 items.
Stocking not_prime items with remaining storage space:
After stocking the prime_eligible items, we have a remaining 157.50 sq ft (500,000 sq ft - (3,095 times x 161.50 sq ft).
Then, we divide by the total square footage for the combination of 2 not_prime items which is mathematically expressed as 157.50 sq ft / (26.40 sq ft + 22.60 sq ft) = 3 times so the total number of not_prime items that we can stock is 6 items 
(3 times x (26.40 sq ft + 22.60 sq ft)).
*/


WITH 
    prime_squared AS
        (SELECT item_type
            ,SUM(square_footage) sum_squared
            ,COUNT(item_id) category_count
            ,TRUNC(500000/SUM(square_footage)) times_stocked_items
            ,TRUNC(500000/SUM(square_footage))*COUNT(item_id) item_count
        FROM inventory
        WHERE item_type = 'prime_eligible'
        GROUP BY item_type
        HAVING SUM(square_footage) < 500000)
        , not_prime_squared AS (
            SELECT item_type
                ,SUM(square_footage) sum_squared
                ,COUNT(item_id) category_count
                ,TRUNC((SELECT (500000-sum_squared*times_stocked_items) FROM prime_squared)/ SUM(square_footage)) AS times_stocked_items
            FROM inventory
            WHERE item_type = 'not_prime'
            GROUP BY item_type
            ),
            not_prime_cnt AS (
                SELECT item_type
                    ,sum_squared
                    ,times_stocked_items
                    ,category_count
                    ,times_stocked_items*category_count item_count
                FROM not_prime_squared
                )

            SELECT item_type
                    -- ,times_stocked_items, category_count
                    , item_count
            FROM prime_squared 
            UNION ALL 
            SELECT item_type
                    -- ,times_stocked_items, category_count
                    , item_count
            FROM not_prime_cnt 
            ;

-- OTHER CLEAR APPROACH 
WITH 
    CTE AS
        (SELECT 
            SUM(CASE WHEN item_type = 'not_prime' THEN 1 ELSE 0 END) n_prime,
            SUM(CASE WHEN item_type = 'prime_eligible' THEN 1 ELSE 0 END) prime,
            SUM(CASE WHEN item_type = 'not_prime' THEN square_footage END) sum_np,
            SUM(CASE WHEN item_type = 'prime_eligible' THEN square_footage END) sum_p
            FROM inventory)

        SELECT 
            'prime_eligible' item_type,
            TRUNC(500000/sum_p,0)*prime item_count
            FROM CTE
        UNION ALL
        SELECT 
            'not_prime' item_type,
            TRUNC((500000-TRUNC(500000/sum_p,0)*sum_p)/sum_np, 0)*n_prime item_count
        FROM CTE
        ;
