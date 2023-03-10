/* 
TikTok
New TikTok users sign up with their emails and each user receives a text confirmation to activate their account. Assume you are given the below tables about emails and texts.
Write a query to display the ids of the users who did not confirm on the first day of sign-up, but confirmed on the second day.

Assumption:
    action_date is the date when the user activated their account and confirmed their sign-up through the text.


emails Table:
Column Name	Type
email_id	integer
user_id	    integer
signup_date	datetime


emails Example Input:
email_id	user_id	    signup_date
125	        7771	    06/14/2022 00:00:00
433	        1052	    07/09/2022 00:00:00


texts Table:
Column Name	    Type
text_id	        integer
email_id	    integer
signup_action	string ('Confirmed', 'Not confirmed')
action_date	    datetime


texts Example Input:
text_id	email_id	signup_action	action_date
6878	125	        Confirmed	    06/14/2022 00:00:00
6997	433	        Not Confirmed	07/09/2022 00:00:00
7000	433	        Confirmed	    07/10/2022 00:00:00

Example Output:
user_id
1052
Explanation:
User 1052 is the only user who confirmed their sign up on the second day.
            **************************************************

*/
-- 1
SELECT DISTINCT FD.user_id
FROM 
  (SELECT A.user_id, B.text_id
          ,B.email_id, B.action_date, B.signup_action
  FROM emails A, texts B
  WHERE 1=1
  AND A.B = B.email_id AND A.signup_date = B.action_date
  -- AND B.signup_action = 'Not confirmed' 
  ) FD, texts SD
WHERE 1=1 
AND FD.email_id = SD.email_id 
AND SD.signup_action = 'Confirmed'
AND EXTRACT(YEAR FROM FD.action_date) = EXTRACT(YEAR FROM SD.action_date)
AND EXTRACT(DAY FROM FD.action_date) - EXTRACT(DAY FROM SD.action_date) = -1
ORDER BY FD.user_id ASC
;

-- 2
SELECT T.user_id FROM 
    (
    SELECT A.user_id, B.action_date,A.email_id
    FROM emails A INNER JOIN texts B
    ON A.email_id = B.email_id AND A.signup_date = B.action_date
    WHERE B.signup_action = 'Not confirmed'
    ) T, texts C
    WHERE T.email_id = C.email_id 
     AND EXTRACT(YEAR FROM T.action_date) = EXTRACT(YEAR FROM C.action_date)
     AND EXTRACT(DAY FROM T.action_date) - EXTRACT(DAY FROM C.action_date) = -1
  ;
