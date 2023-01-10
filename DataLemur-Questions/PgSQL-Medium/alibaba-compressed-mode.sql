/*
Alibaba
URL : "https://datalemur.com/questions/alibaba-compressed-mode"

You are trying to find the most common (aka the mode) number of items bought per order on Alibaba.
However, instead of doing analytics on all Alibaba orders, you have access to a summary table, which describes how many items were in an order (item_count), and the number of orders that had that many items (order_occurrences).
In case of multiple item counts, display the item_counts in ascending order.

items_per_order Table:
Column Name	        Type
item_count	        integer
order_occurrences	integer


items_per_order Example Input:
item_count	order_occurrences
1	        500
2	        1000
3	        800
4	        1000


Example Output:
mode
2
4


Explanation
The most common number of order_occurrences is 1000. Both item counts of 2 and 4 fit this.
*/

SELECT DISTINCT T.item_count FROM
  (SELECT item_count,order_occurrences
        ,DENSE_RANK() OVER(ORDER BY order_occurrences DESC)  rnk
    FROM items_per_order 
    ORDER BY rnk ASC) T
WHERE T.rnk = 1 