/* LinkedIn  
URL : https://datalemur.com/questions/matching-skills
Given a table of candidates and their skills, you're tasked with finding the candidates 
best suited for an open Data Science job. You want to find candidates who are proficient 
in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job. 
Sort the the output by candidate ID in ascending order.

Assumption:
    There are no duplicates in the candidates table.

candidates Table:
Column Name 	Type
candidate_id	integer
skill	        varchar


candidates Example Input:
candidate_id	skill
    123	    Python
    123	    Tableau
    123	    PostgreSQL
    234	    R
    234	    PowerBI
    234	    SQL Server
    345	    Python
    345	    Tableau

Example Output:
candidate_id
    123

                **************************************************
*/

SELECT T.CANDIDATE_ID
FROM
  (SELECT DISTINCT T.* 
  FROM CANDIDATES T
  WHERE 1=1
    AND SKILL IN ('Python','Tableau','PostgreSQL')
  ORDER BY CANDIDATE_ID DESC) T
GROUP BY CANDIDATE_ID
HAVING COUNT(SKILL) = 3
;


