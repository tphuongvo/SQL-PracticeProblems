/*
Verizon
The first 3 digits of American phone numbers, after the international code (of +1) are called the area code.

How many phone calls have either a caller or receiver with a phone number with a Manhattan NYC area code (ie. +1-212-XXX-XXXX).

phone_calls Table:
Column Name	Type
caller_id	integer
receiver_id	integer
call_time	timestamp


phone_calls Example Input:
caller_id	receiver_id	call_time
1	        2	        2022-07-04 10:13:49
1	        5	        2022-08-21 23:54:56
5	        1	        2022-05-13 17:24:06
5	        6	        2022-03-18 12:11:49


phone_info Table:
Column Name	    Type
caller_id	    integer
country_id	    integer
network	        integer
phone_number	string


phone_info Example Input:
caller_id	country_id	    network	phone_number
1	        US	Verizon	    +1-212-897-1964
2	        US	Verizon	    +1-703-346-9529
3	        US	Verizon	    +1-650-828-4774
4	        US	Verizon	    +1-415-224-6663
5	        IN	Vodafone	+91 7503-907302
6	        IN	Vodafone	+91 2287-664895


Example Output:
nyc_count
3
Explanation
Caller ID 1 is the only NYC phone number (see the 212 after the +1). Caller 1 is involved in 3 calls.
*/

WITH contact_id AS 
    (
      SELECT DISTINCT
        caller_id
      FROM phone_info
        WHERE SUBSTR(phone_number,4, 3) = '212'
    ) 
    
  SELECT COUNT(*) nyc_count
  FROM phone_calls 
  WHERE caller_id  IN (SELECT * FROM CONTACT_ID)
    OR receiver_id IN (SELECT * FROM CONTACT_ID)
;