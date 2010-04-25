select lpad('=',10,'=') || 'dates' || lpad('=',10,'=') from dual;
select to_char(sysdate,'Dy Mon DD HH24:MM:SS YYYY') from dual;
select to_char(sysdate,'Dy') from dual;
select to_char(sysdate,'Mon') from dual;
select to_char(sysdate,'YYYY') from dual; 
select to_char(add_months(sysdate,-1),'Dy Mon DD HH24:MM:SS YYYY') from dual;
select to_char(add_months(sysdate,-1),'Dy') from dual;
select to_char(add_months(sysdate,-1),'Mon') from dual;
select to_char(add_months(sysdate,-1),'YYYY') from dual; 

select lpad('=',10,'=') || 'mind_logs' || lpad('=',10,'=') from dual;
select value from v$parameter where name = 'user_dump_dest';
select value from v$parameter where name = 'background_dump_dest'; 