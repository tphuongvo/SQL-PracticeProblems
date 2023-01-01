/*
Facebook
URL: https://datalemur.com/questions/click-through-rate

Assume you have an events table on app analytics. Write a query to get the app’s click-through rate (CTR %) in 2022. 
Output the results in percentages rounded to 2 decimal places.

Notes:
    Percentage of click-through rate = 100.0 * Number of clicks / Number of impressions
    To avoid integer division, you should multiply the click-through rate by 100.0, not 100.


events Table:
Column Name	    Type
app_id	        integer
event_type	    string
timestamp	    datetime


events Example Input:
app_id	event_type	timestamp
123	    impression	07/18/2022 11:36:12
123	    impression	07/18/2022 11:37:12
123	    click	    07/18/2022 11:37:42
234	    impression	07/18/2022 14:15:12
234	    click	    07/18/2022 14:16:12

Example Output:
app_id	ctr
123	    50.00
234	    100.00

Explanation
App 123 has a CTR of 50.00% because this app receives 1 click out of the 2 impressions. Hence, it's 1/2 = 50.00%.
            **************************************************
*/

SELECT T.app_id
      ,ROUND(100.0*(MAX(T.click_cnt::numeric)/MAX(T.imp_cnt::numeric)),2) ctr
FROM
  (
    SELECT 
      T.app_id
      , T.event_type, T.cnt
      ,LEAD(T.cnt) OVER(PARTITION BY T.app_id ORDER BY T.event_type ASC) imp_cnt
      ,LAG(T.cnt) OVER(PARTITION BY T.app_id ORDER BY T.event_type ASC) click_cnt
    FROM
      (
        SELECT app_id, event_type
              , COUNT(timestamp) cnt
        FROM events
        WHERE 1=1
         AND EXTRACT(YEAR FROM timestamp) = '2022'
         AND event_type IN ('click','impression')
        GROUP BY app_id, event_type 
        ORDER BY app_id, event_type ASC
      ) T
    GROUP BY T.app_id, T.event_type,T.cnt
  ) T
WHERE 1=1
GROUP BY T.app_id
;