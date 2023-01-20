/*
Google
URL: https://datalemur.com/questions/median-search-freq
Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on their TV ad: 
the median number of searches a person made last year.
However, at Google scale, querying the 2 trillion searches is too costly. 
Luckily, you have access to the summary table which tells you the number of searches made last year and how many Google users fall into that bucket.

Write a query to report the median of searches made by a user. Round the median to one decimal point.

search_frequency Table:
Column Name	Type
searches	integer
num_users	integer


search_frequency Example Input:
searches	num_users
1	        2
2	        2
3	        3
4	        1


Example Output:
median
2.5
By expanding the search_frequency table, we get [1, 1, 2, 2, 3, 3, 3, 4] which has a median of 2.5 searches per user.
*/

-- Use range 
SELECT 
  ROUND(SUM(T.searches)*1.0/2,1) median
  FROM
    (
      SELECT *
      ,SUM(num_users) OVER(ORDER BY searches) as running_sum 
      ,SUM(num_users) OVER() total_
  FROM search_frequency
  ) T 
WHERE (T.total_/2) BETWEEN (T.running_sum - T.num_users) AND T.running_sum 
GROUP BY T.total_
;

-- Use PERCENTILE_CONT function
-- Create a new column to genterate distribution:
SELECT 
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY T.searches) AS median
FROM (SELECT 
      searches,num_users
      ,GENERATE_SERIES(1,num_users)
      FROM search_frequency
      ORDER BY searches
    ) T

;