select lpad('=',10,'=') || 'Log_files' || lpad('=',10,'=') from dual;
select * from v$logfile;
-----------------------------------------
 
select lpad('=',10,'=') || 'Average_log_switch_rate' || lpad('=',10,'=') from dual;
select avg(x.first_time-y.first_time)*24*60 average, min(x.first_time-y.first_time)*24*60 minimum from gv$log_history x, gv$log_history y
where x.RECID-1=y.RECID and x.first_time>y.first_time
and x.FIRST_TIME>(sysdate-30)
-----------------------------------------
 
select lpad('=',10,'=') || 'Log_switch_statistics' || lpad('=',10,'=') from dual;
SELECT * FROM (
SELECT * FROM (
SELECT TO_CHAR(FIRST_TIME, 'DD/MM') AS "DAY"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '00', 1, 0)), '99') "00:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '01', 1, 0)), '99') "01:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '02', 1, 0)), '99') "02:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '03', 1, 0)), '99') "03:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '04', 1, 0)), '99') "04:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '05', 1, 0)), '99') "05:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '06', 1, 0)), '99') "06:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '07', 1, 0)), '99') "07:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '08', 1, 0)), '99') "08:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '09', 1, 0)), '99') "09:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '10', 1, 0)), '99') "10:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '11', 1, 0)), '99') "11:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '12', 1, 0)), '99') "12:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '13', 1, 0)), '99') "13:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '14', 1, 0)), '99') "14:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '15', 1, 0)), '99') "15:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '16', 1, 0)), '99') "16:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '17', 1, 0)), '99') "17:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '18', 1, 0)), '99') "18:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '19', 1, 0)), '99') "19:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '20', 1, 0)), '99') "20:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '21', 1, 0)), '99') "21:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '22', 1, 0)), '99') "22:00"
, TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '23', 1, 0)), '99') "23:00"
FROM V$LOG_HISTORY
WHERE extract(year FROM FIRST_TIME) = extract(year FROM sysdate)
GROUP BY TO_CHAR(FIRST_TIME, 'DD/MM')
) ORDER BY TO_DATE(extract(year FROM sysdate) || DAY, 'YYYY DD/MM') DESC
) WHERE ROWNUM < 8;
-----------------------------------------
 
select lpad('=',10,'=') || 'Archive_log_status' || lpad('=',10,'=') from dual;

-----------------------------------------
 

select lpad('=',10,'=') || 'Log_buffer_size' || lpad('=',10,'=') from dual;
select value/1024/1024 as MB from v$parameter where name='log_buffer'
-----------------------------------------
 
select lpad('=',10,'=') || 'Log_member_size' || lpad('=',10,'=') from dual;
select distinct bytes/1024/1024 as mb from v$log
-----------------------------------------

 select lpad('=',10,'=') || 'FIN' || lpad('=',10,'=') from dual;   
