select lpad('=',10,'=') || 'activecalls' || lpad('=',10,'=') from dual;
SELECT mts, callstarted, status, COUNT(*)
  FROM activecalls
 GROUP BY mts, callstarted, status
 ORDER BY 1, 2;
----------------------------------------- 

select lpad('=',10,'=') || 'activecalls_segment_name' || lpad('=',10,'=') from dual;
SELECT SEGMENT_NAME, SUM(BYTES) BYTES, ceil(SUM(BYTES) / (1024 * 1024)) MB
  FROM DBA_SEGMENTS
 WHERE OWNER = 'MIND'
   AND SEGMENT_NAME LIKE 'ACTIVECALLS%'
   AND SEGMENT_NAME NOT LIKE '%ERROR%'
 GROUP BY SEGMENT_NAME;
 ----------------------------------------- 

select lpad('=',10,'=') || 'rtsstatusqueue' || lpad('=',10,'=') from dual;
SELECT COUNT(*) FROM RTSSTATUSQUEUE;
----------------------------------------- 

select lpad('=',10,'=') || 'rtsstatusqueue_segment_name' || lpad('=',10,'=') from dual;
SELECT SEGMENT_NAME, SUM(BYTES) BYTES, ceil(SUM(BYTES) / (1024 * 1024)) MB
  FROM DBA_SEGMENTS
 WHERE OWNER = 'MIND'
   AND SEGMENT_NAME LIKE 'RTSSTATUSQUEUE%'
 GROUP BY SEGMENT_NAME; 
----------------------------------------- 

select lpad('=',10,'=') || 'statusqueue' || lpad('=',10,'=') from dual;
SELECT  COUNT(*)  FROM STATUSQUEUE;
----------------------------------------- 

select lpad('=',10,'=') || 'statusqueuedba' || lpad('=',10,'=') from dual;
SELECT   SEGMENT_NAME, SUM(BYTES) BYTES, ceil(SUM(BYTES)/(1024*1024)) MB
FROM     DBA_SEGMENTS
WHERE    OWNER = 'MIND' AND SEGMENT_NAME LIKE 'STATUSQUEUE%'
GROUP BY SEGMENT_NAME; 
----------------------------------------- 

select lpad('=',10,'=') || 'voipcdrqueue' || lpad('=',10,'=') from dual;
SELECT  COUNT(*)  FROM VOIPCDRQUEUE;
----------------------------------------- 

select lpad('=',10,'=') || 'voipcdrqueue_segment_name' || lpad('=',10,'=') from dual;
SELECT   SEGMENT_NAME, SUM(BYTES) BYTES, ceil(SUM(BYTES)/(1024*1024)) MB
FROM     DBA_SEGMENTS
WHERE    OWNER = 'MIND' AND SEGMENT_NAME LIKE 'VOIPCDRQUEUE%'
GROUP BY SEGMENT_NAME; 
----------------------------------------- 
 
select lpad('=',10,'=') || 'invalidobjects' || lpad('=',10,'=') from dual;
select A.Owner Oown,
       A.Object_Name Oname,
       A.Object_Type Otype,
       'Miss Pkg Body' Prob
  from DBA_OBJECTS A
 where A.Object_Type = 'PACKAGE'
   and A.Owner not in ('SYS', 'SYSTEM')
   and not exists (select 'x'
          from DBA_OBJECTS B
         where B.Object_Name = A.Object_Name
           and B.Owner = A.Owner
           and B.Object_Type = 'PACKAGE BODY')
union
select Owner Oown, Object_Name Oname, Object_Type Otype, 'Invalid Obj' Prob
  from DBA_OBJECTS
 where Object_Type in ('PROCEDURE', 'PACKAGE', 'FUNCTION', 'TRIGGER',
        'PACKAGE BODY', 'VIEW')
   and Owner not in ('SYS', 'SYSTEM')
   and Status != 'VALID'
 order by 1, 4, 3, 2; 
----------------------------------------- 

select lpad('=',10,'=') || 'brokenjobs' || lpad('=',10,'=') from dual;
select * from dba_jobs where broken='Y';
----------------------------------------- 

select lpad('=',10,'=') || 'statistics' || lpad('=',10,'=') from dual;
select 'values of last_analyzed in USER_TABLES, USER_TAB_PARTITIONS etc' from dual;
----------------------------------------- 

select lpad('=',10,'=') || 'statistics_user_indexes' || lpad('=',10,'=') from dual;
SELECT (sysdate - to_date('19700101', 'YYYYMMDD')) * 86400 - (max(last_analyzed) - to_date('19700101', 'YYYYMMDD')) * 86400,
       table_name,
       max(last_analyzed)
  from user_indexes
 group by table_name
 order by 1 desc;
----------------------------------------- 

select lpad('=',10,'=') || 'statistics_user_tab_partitions' || lpad('=',10,'=') from dual;
SELECT (sysdate - to_date('19700101', 'YYYYMMDD')) * 86400 - (max(last_analyzed) - to_date('19700101', 'YYYYMMDD')) * 86400,
       table_name,
       max(last_analyzed)
  FROM user_tab_partitions
 group by table_name
 order by 1 desc; 
----------------------------------------- 

select lpad('=',10,'=') || 'statistics_user_tables' || lpad('=',10,'=') from dual;
SELECT (sysdate - to_date('19700101', 'YYYYMMDD')) * 86400 - (max(last_analyzed) - to_date('19700101', 'YYYYMMDD')) * 86400,
       table_name,
       max(last_analyzed)
  FROM user_tables
 group by table_name
 order by 1 desc; 
----------------------------------------- 

select lpad('=',10,'=') || 'Tables' || lpad('=',10,'=') from dual;
select trunc(last_analyzed) collect_date, count(*) number_of_objects
from user_tables
group by trunc(last_analyzed)
order by 1 desc
----------------------------------------- 

select lpad('=',10,'=') || 'Partitions' || lpad('=',10,'=') from dual;
select trunc(last_analyzed) collect_date, count(*) number_of_objects
from user_tab_partitions
group by trunc(last_analyzed)
order by 1 desc
----------------------------------------- 

select lpad('=',10,'=') || 'Sequence_limits' || lpad('=',10,'=') from dual;
select sequence_name seq,
       to_char(max_value) limit_,
       last_number current_, to_char((to_number(to_char(max_value)) - last_number) / increment_by) remaining,
       decode(greatest(100-(trunc((to_char((to_number(to_char(max_value)) - last_number) / increment_by)/to_char(max_value))*100,2)), 80),80,'no','yes') problematic
from user_sequences;
-----------------------------------------

select lpad('=',10,'=') || 'Resource_limits' || lpad('=',10,'=') from dual;
select resource_name res, current_utilization current_u, max_utilization max, limit_value, decode(greatest(max_utilization, limit_value*0.8),limit_value*0.8, 'no','yes') problematic
        from v$resource_limit where limit_value not like '%UNLIMITED%'
union all
select resource_name, current_utilization, max_utilization, limit_value, 'no' problematic
        from v$resource_limit where limit_value like '%UNLIMITED%';
-----------------------------------------

select lpad('=',10,'=') || 'Account_usage' || lpad('=',10,'=') from dual;
select case
         when parametervalue = 0 then
          (select 'mod 10 check, ' || (select count(*) from accounts) ||
                  ' out of ' ||
                  ((select (9 * power(10, parametervalue - 2))
                      from sysparameter
                     where parameterkey = 'MAX_CUST_CODE_LEN') /
                  (select parametervalue
                      from sysparameter
                     where parameterkey = 'CUST_CODE_MIN_GAP')) ||
                  ' representing ' ||
                  trunc((select count(*) from accounts) /
                        ((select (9 * power(10, parametervalue - 2))
                            from sysparameter
                           where parameterkey = 'MAX_CUST_CODE_LEN') /
                        (select parametervalue
                            from sysparameter
                           where parameterkey = 'CUST_CODE_MIN_GAP')),
                        2) * 100 || ' percents'
             from dual)
         when parametervalue = -1 then
          (select 'no check, ' || (select count(*) from accounts) ||
                  ' out of ' ||
                  (select (power(10, parametervalue))
                     from sysparameter
                    where parameterkey = 'MAX_CUST_CODE_LEN') /
                  (select parametervalue
                     from sysparameter
                    where parameterkey = 'CUST_CODE_MIN_GAP') ||
                  ' representing ' ||
                  trunc(((select count(*) from accounts) /
                        (select (power(10, parametervalue))
                            from sysparameter
                           where parameterkey = 'MAX_CUST_CODE_LEN') /
                        (select parametervalue
                            from sysparameter
                           where parameterkey = 'CUST_CODE_MIN_GAP')),
                        2) * 100 || ' percent'
             from dual)
       end as account_level
  from sysparameter
 where parameterkey = 'CHECK_DIGIT_METHOD';
-----------------------------------------

select lpad('=',10,'=') || 'Usercode_usage' || lpad('=',10,'=') from dual;
select case
         when parametervalue = 'M10' then
          (select 'mod 10 check, ' || (select count(*) from asvoip) ||
                  ' out of ' ||
                  ((select (9 * power(10, parametervalue - 2))
                      from sysparameter
                     where parameterkey = 'MAX_USER_CODE_LEN') /
                  (select parametervalue
                      from sysparameter
                     where parameterkey = 'USER_CODE_MIN_GAP')) ||
                  ' representing ' ||
                  trunc(((select count(*) from asvoip) /
                        ((select (9 * power(10, parametervalue - 2))
                             from sysparameter
                            where parameterkey = 'MAX_USER_CODE_LEN') /
                        (select parametervalue
                             from sysparameter
                            where parameterkey = 'USER_CODE_MIN_GAP'))),
                        2) * 100 || ' percent'
             from dual)
         when parametervalue is null then
          (select 'no check, ' || (select count(*) from asvoip) || ' out of ' ||
                  (select (power(10, parametervalue))
                     from sysparameter
                    where parameterkey = 'MAX_USER_CODE_LEN') /
                  (select parametervalue
                     from sysparameter
                    where parameterkey = 'USER_CODE_MIN_GAP') ||
                  ' representing ' ||
                  trunc(((select count(*) from asvoip) /
                        (select (power(10, parametervalue))
                            from sysparameter
                           where parameterkey = 'MAX_USER_CODE_LEN') /
                        (select parametervalue
                            from sysparameter
                           where parameterkey = 'USER_CODE_MIN_GAP')),
                        2) * 100 || ' percent'
             from dual)
       end as usercode_level
  from sysparameter
 where parameterkey = 'USER_CODE_CHECK_DIGIT_METHOD'
-----------------------------------------

select lpad('=',10,'=') || 'FIN' || lpad('=',10,'=') from dual;   
