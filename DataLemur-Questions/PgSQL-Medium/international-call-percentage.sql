/*
Verizon
URL: https://datalemur.com/questions/international-call-percentage
A phone call is considered an international call when the person calling is in a different country than the person receiving the call.
What percentage of phone calls are international? Round the result to 1 decimal.

Assumption:

The caller_id in phone_info table refers to both the caller and receiver.
phone_calls Table:
Column Name	Type
caller_id	integer
receiver_id	integer
call_time	timestamp


phone_calls Example Input:
caller_id	receiver_id	    call_time
1	        2	            2022-07-04 10:13:49
1	        5	            2022-08-21 23:54:56
5	        1	            2022-05-13 17:24:06
5	        6	            2022-03-18 12:11:49


phone_info Table:
Column Name	    Type
caller_id	    integer
country_id	    integer
network	        integer
phone_number	string


phone_info Example Input:
caller_id	country_id	network	    phone_number
1	        US	        Verizon	    +1-212-897-1964
2	        US	        Verizon	    +1-703-346-9529
3	        US	        Verizon	    +1-650-828-4774
4	        US	        Verizon	    +1-415-224-6663
5	        IN	        Vodafone	+91 7503-907302
6	        IN	        Vodafone	+91 2287-664895


Example Output:
international_calls_pct
50.0
Explanation
There is a total of 4 calls with 2 of them being international calls (from caller_id 1 => receiver_id 5, and caller_id 5 => receiver_id 1).
Thus, 2/4 = 50.0%
*/

    WITH caller_country_table 
      AS (
        SELECT A.*,
          B.country_id AS caller_country
        FROM phone_calls A, phone_info B 
          WHERE A.caller_id = B.caller_id)
          , receiver_country_table AS (SELECT A.*,
          B.country_id AS receiver_country
        FROM phone_calls A, phone_info B 
          WHERE A.receiver_id = B.caller_id)
          
      , mapping_table AS (
            SELECT A.caller_id, B.receiver_id
              , A.caller_country, B.receiver_country 
              FROM caller_country_table A   
                LEFT JOIN receiver_country_table B   
                ON A.caller_id = B.caller_id AND A.receiver_id = B.receiver_id
              )
            SELECT 
              ROUND(100.0* 
              (SELECT COUNT(*) FROM mapping_table WHERE caller_country <> receiver_country)/COUNT(*),1
              )
            FROM mapping_table