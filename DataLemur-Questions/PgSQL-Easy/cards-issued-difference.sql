/*
JPMorgan Chase
URL: https://datalemur.com/questions/cards-issued-difference
Your team at JPMorgan Chase is soon launching a new credit card, and to gain some context, you are analyzing how many credit cards were issued each month.
Write a query that outputs the name of each credit card and the difference in issued amount between the month with the most cards issued, and the least cards issued. Order the results according to the biggest difference.

monthly_cards_issued Table:
Column Name	        Type
issue_month	        integer
issue_year	        integer
card_name	        string
issued_amount	    integer


monthly_cards_issued Example Input:
card_name	            issued_amount	issue_month	issue_year
Chase Freedom Flex	    55000	        1	        2021
Chase Freedom Flex	    60000	        2	        2021
Chase Freedom Flex	    65000	        3	        2021
Chase Freedom Flex	    70000	        4	        2021
Chase Sapphire Reserve	170000	        1	        2021
Chase Sapphire Reserve	175000	        2	        2021
Chase Sapphire Reserve	180000	        3	        2021

Example Output:
card_name	            difference
Chase Freedom Flex	    15000
Chase Sapphire Reserve	10000

Explanation
Chase Freedom Flex's best month was 70k cards issued and the worst month was 55k cards, so the difference is 15k cards.
Chase Sapphire Reserve’s best month was 180k cards issued and the worst month was 170k cards, so the difference is 10k cards.

*/
SELECT T.card_name
    , MAX(T.total_amt) - MIN(T.total_amt) AS difference
FROM
  (
  SELECT card_name, issue_month, issue_year, SUM(issued_amount) total_amt
        ,ROW_NUMBER() OVER(PARTITION BY card_name ORDER BY SUM(issued_amount) DESC) MAX_AMT
        ,ROW_NUMBER() OVER(PARTITION BY card_name ORDER BY SUM(issued_amount) ASC) MIN_AMT
  FROM monthly_cards_issued
  WHERE 1=1
  GROUP BY card_name, issue_month, issue_year
  ) T
WHERE 1=1 AND T.MAX_AMT = 1 OR T.MIN_AMT = 1
GROUP BY T.card_name
ORDER BY difference DESC
;