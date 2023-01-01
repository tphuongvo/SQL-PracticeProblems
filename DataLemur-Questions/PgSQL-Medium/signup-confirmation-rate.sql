/*
TikTok
URL: https://datalemur.com/questions/signup-confirmation-rate
New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. Users may receive multiple text messages for account confirmation until they have confirmed their new account.

Write a query to find the activation rate of the users. Round the percentage to 2 decimal places.

Definitions:
    emails table contain the information of user signup details.
    texts table contains the users' activation information.
    As of 29 Nov 2022, the term confirmation rate is changed to activation rate to reflect the nature of the new user activation process.

emails Table:
Column Name	Type
email_id	integer
user_id	    integer
signup_date	datetime


emails Example Input:
email_id	user_id	signup_date
125	        7771	06/14/2022 00:00:00
236	        6950	07/01/2022 00:00:00
433	        1052	07/09/2022 00:00:00


texts Table:
Column Name	    Type
text_id	        integer
email_id	    integer
signup_action	varchar


texts Example Input:
text_id	email_id	signup_action
6878	125	        Confirmed
6920	236	        Not Confirmed
6994	236	        Confirmed

'Confirmed' in signup_action means the user has activated their account and successfully completed the signup process.

Example Output:
confirm_rate
0.67

Explanation:
67% of users have successfully completed their signup and activated their accounts. The remaining 33% have not yet replied to the text to confirm their signup.
*/

SELECT 
ROUND(1.0*SUM(CASE WHEN t.signup_action = 'Confirmed' THEN 1 ELSE 0 END)/
COUNT(e.user_id),2) as rate
FROM emails e join texts t on 
e.email_id=t.email_id;