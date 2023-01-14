/*
Google
URL : https://datalemur.com/questions/odd-even-measurements
Assume you are given the table containing measurement values obtained from a Google sensor over several days. 
Measurements are taken several times within a given day.
Write a query to obtain the sum of the odd-numbered and even-numbered measurements on a particular day, in two different columns. 
Refer to the Example Output below for the output format.

Definition:
    1st, 3rd, and 5th measurements taken within a day are considered odd-numbered measurements and the 2nd, 4th, and 6th measurements are even-numbered measurements.


measurements Table:
Column Name	        Type
measurement_id	    integer
measurement_value	decimal
measurement_time	datetime


measurements Example Input:
measurement_id	measurement_value	measurement_time
131233	        1109.51	            07/10/2022 09:00:00
135211	        1662.74	            07/10/2022 11:00:00
523542	        1246.24	            07/10/2022 13:15:00
143562	        1124.50	            07/11/2022 15:00:00
346462	        1234.14	            07/11/2022 16:45:00


Example Output:
measurement_day	        odd_sum	    even_sum
07/10/2022 00:00:00	    2355.75	    1662.74
07/11/2022 00:00:00	    1124.50	    1234.14


Explanation
On 07/11/2022, there are only two measurements. In chronological order, the first measurement (odd-numbered) is 1124.50, and the second measurement(even-numbered) is 1234.14.
*/
SELECT DATE(T.measurement_time) AS measurement_day
    ,SUM(CASE WHEN MOD(T.RN,2) <> 0 THEN T.measurement_value ELSE NULL END) AS odd_sum
    ,SUM(CASE WHEN MOD(T.RN,2) = 0 THEN T.measurement_value ELSE NULL END) AS even_sum
FROM
  (SELECT measurement_id, measurement_value, measurement_time
      ,ROW_NUMBER() OVER(PARTITION BY DATE(measurement_time) ORDER BY measurement_time ASC) AS RN
    FROM measurements
    ORDER BY DATE(measurement_time) ASC, EXTRACT(HOUR FROM measurement_time) ASC
  ) T
GROUP BY DATE(T.measurement_time) 
ORDER BY DATE(T.measurement_time) ASC
;