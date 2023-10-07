alter session set nls_date_format = 'DD-MM-YYYY HH24:MI:SS';

-- Generate data
-- Recursive solution


        WITH TRANSACTIONS AS (
          SELECT 
             TO_DATE('2022-07-24 00:19:00','yyyy-mm-dd hh24:mi:ss')  AS DT
                 ,'08bd482a56071a97f42ef8ba965fb3380de72b7f46943ae5d7c0703731af4e57' AS SENDER
                ,'213b1501fa06010636f0c22d5c6725147122f0840658d12f16da64c7dd1be98f' AS RECIPIENT
                ,'24667' AS AMOUNT
         FROM DUAL  
            
           UNION ALL
           SELECT 
             TO_DATE('2022-07-24 00:33:00','yyyy-mm-dd hh24:mi:ss')  AS DT
                 ,'08bd482a56071a97f42ef8ba965fb3380de72b7f46943ae5d7c0703731af4e57' AS SENDER
                ,'0a75e6d0efc7645f9690f630b9f5a143ea7a002290b4676b148fd38f03338558' AS RECIPIENT
                ,'42143' AS AMOUNT
         FROM DUAL 
            UNION ALL
           SELECT 
             TO_DATE('2022-07-24 01:01:00','yyyy-mm-dd hh24:mi:ss')  AS DT
                 ,'08bd482a56071a97f42ef8ba965fb3380de72b7f46943ae5d7c0703731af4e57' AS SENDER
                ,'5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8' AS RECIPIENT
                ,'41280' AS AMOUNT
         FROM DUAL 
         UNION ALL
         SELECT 
             TO_DATE('2022-07-24 02:19:00','yyyy-mm-dd hh24:mi:ss')  AS DT
                 ,'08bd482a56071a97f42ef8ba965fb3380de72b7f46943ae5d7c0703731af4e58' AS SENDER
                ,'213b1501fa06010636f0c22d5c6725147122f0840658d12f16da64c7dd1be98f' AS RECIPIENT
                ,'24667' AS AMOUNT
         FROM DUAL  
            
           UNION ALL
           SELECT 
             TO_DATE('2022-07-24 04:20:00','yyyy-mm-dd hh24:mi:ss')  AS DT
                 ,'08bd482a56071a97f42ef8ba965fb3380de72b7f46943ae5d7c0703731af4e58' AS SENDER
                ,'0a75e6d0efc7645f9690f630b9f5a143ea7a002290b4676b148fd38f03338558' AS RECIPIENT
                ,'42143' AS AMOUNT
         FROM DUAL 
         
         )
--         SELECT *  FROM TRANSACTIONS;
        ,
        TIME_WINDOW(SENDER,START_WINDOW, END_WINDOW,STEP,START_TIME, END_TIME) AS (
                SELECT SENDER, MIN(DT) START_WINDOW
                        , MIN(DT)+1/24 END_WINDOW
                        , MAX(1/24) STEP 
                        , MIN(DT) START_TIME
                        , MAX(DT) END_TIME
                FROM TRANSACTIONS
                GROUP BY SENDER
                UNION ALL
                
                SELECT SENDER, END_WINDOW+1/24/60 START_WINDOW, END_WINDOW+STEP END_WINDOW 
                        , (1/24)*STEP STEP
                        ,START_TIME, END_TIME
                FROM TIME_WINDOW
                WHERE  END_WINDOW <= END_TIME
              )
         , BASE_TABLE AS (     
                        SELECT DISTINCT * FROM TIME_WINDOW
                        )
        , CNT_TB AS (
                SELECT  A.SENDER,A.START_WINDOW, A.END_WINDOW
                    , COUNT(B.DT) TRANSACTIONS_COUNT, SUM(B.AMOUNT) TRANSACTIONS_SUM, MAX(B.DT) SEQUENCE_START, MIN(B.DT) SEQUENCE_END
                 FROM BASE_TABLE A LEFT JOIN TRANSACTIONS B
                 ON A.SENDER = B.SENDER
                 WHERE B.DT BETWEEN A.START_WINDOW AND A.END_WINDOW
                 GROUP BY  A.SENDER, A.START_WINDOW, A.END_WINDOW 
                 )
            SELECT SENDER, START_WINDOW, END_WINDOW, TRANSACTIONS_COUNT, TRANSACTIONS_SUM, SEQUENCE_START, SEQUENCE_END FROM (
                SELECT SENDER, START_WINDOW, END_WINDOW, TRANSACTIONS_COUNT, TRANSACTIONS_SUM, SEQUENCE_START, SEQUENCE_END
                    , ROW_NUMBER() OVER(PARTITION BY SENDER ORDER BY START_WINDOW) AS RN
                 FROM CNT_TB) WHERE RN = 1 AND TRANSACTIONS_SUM >= 150
            ;
 
--  SELECT SYSDATE,SYSDATE+1/24/60 FROM DUAL;
 
 
 
 
 
 
        