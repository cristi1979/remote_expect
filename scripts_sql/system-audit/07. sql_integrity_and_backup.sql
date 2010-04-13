select lpad('=',10,'=') || 'Control_files' || lpad('=',10,'=') from dual;
select * from v$controlfile;
-----------------------------------------
 
select lpad('=',10,'=') || 'Database_growth_since_last_audit' || lpad('=',10,'=') from dual;
select to_char(creation_time, 'RRRR Month') "Month", sum(bytes)/1024/1024 "Growth in Meg" 
from sys.v_$datafile
where creation_time > SYSDATE-90
group by to_char(creation_time, 'RRRR Month'); 
-----------------------------------------
 
select lpad('=',10,'=') || 'Backup' || lpad('=',10,'=') from dual;

-----------------------------------------
 
select lpad('=',10,'=') || 'FIN' || lpad('=',10,'=') from dual;   