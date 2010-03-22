select to_char(sysdate,'Dy Mon DD HH24:MM:SS YYYY') from dual;
select to_char(sysdate,'Dy') from dual;
select to_char(sysdate,'Mon') from dual;
select to_char(sysdate,'YYYY') from dual; 
select to_char(add_months(sysdate,-1),'Dy Mon DD HH24:MM:SS YYYY') from dual;
select to_char(add_months(sysdate,-1),'Dy') from dual;
select to_char(add_months(sysdate,-1),'Mon') from dual;
select to_char(add_months(sysdate,-1),'YYYY') from dual;
