/*
Tesla is investigating bottlenecks in their production, and they need your help to 
extract the relevant data. Write a SQL query that determines which parts have begun 
the assembly process but are not yet finished.

    Assumption
Table parts_assembly contains all parts in production.

parts_assembly  Table
Column Name	    Type
part	        string
finish_date	    datetime
assembly_step	integer

parts_assembly Example Input
part	finish_date	assembly_step
battery	01/22/2022 00:00:00	1
battery	02/22/2022 00:00:00	2
battery	03/22/2022 00:00:00	3
bumper	01/22/2022 00:00:00	1
bumper	02/22/2022 00:00:00	2
bumper		                3
bumper		                4

Example Output
part
bumper
            **************************************************
*/
SELECT A.PART FROM PARTS_ASSEMBLY A,
    (SELECT PART, MAX(ASSEMBLY_STEP) ASSEMBLY_STEP
    FROM PARTS_ASSEMBLY 
    WHERE 1=1
    GROUP BY PART ORDER BY PART DESC) B
  WHERE 1=1
   AND A.PART= B.PART AND A.ASSEMBLY_STEP = B.ASSEMBLY_STEP
   AND A.FINISH_DATE IS NULL
  ORDER BY A.PART ASC
   ;