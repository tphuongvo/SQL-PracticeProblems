/*
UnitedHealth
URL: https://datalemur.com/questions/frequent-callers
UnitedHealth has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs – whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.
Write a query to find how many UHG members made 3 or more calls. case_id column uniquely identifies each call made.


callers Table:
Column Name	        Type
policy_holder_id	integer
case_id	            varchar
call_category	    varchar
call_received	    timestamp
call_duration_secs	integer
original_order	    integer


callers Example Input:
policy_holder_id	case_id	                call_category	call_received	        call_duration_secs	original_order
50837000	        dc63-acae-4f39-bb04	    claims	        03/09/2022 02:51:00	    205	                130
50837000	        41be-bebe-4bd0-a1ba	    IT_support	    03/12/2022 05:37:00	    254	                129
50936674	        12c8-b35c-48a3-b38d	    claims	        05/31/2022 7:27:00	    240	                31
50886837	        d0b4-8ea7-4b8c-aa8b	    IT_support	    03/11/2022 3:38:00	    276	                16
50886837	        a741-c279-41c0-90ba		                03/19/2022 10:52:00	    131	                325
50837000	        bab1-3ec5-4867-90ae	    benefits	    05/13/2022 18:19:00	    228	                339


Example Output:
member_count
1

Explanation:
The only caller who made 3 or more calls is member ID 50837000.
*/
SELECT COUNT(T.count) member_count FROM
(SELECT policy_holder_id,COUNT(DISTINCT case_id)
FROM callers
WHERE 1=1 
GROUP BY policy_holder_id) T
WHERE 1=1
  AND T.count >=3;