select lpad('=',10,'=') || 'Billing cycle performance v6' || lpad('=',10,'=') from dual;
select trunc(start_time), trunc(runduration/60) execution_time, num_of_generated_invoices invoices, trunc(num_of_generated_invoices/(runduration/60)) invoices_per_minute  from bc_history h, taskslog l
where l.resultdescription like 'Succes%' and taskid=1
and trunc(l.rundatetime)=trunc(h.start_time)
and to_char(rundatetime, 'mi')=to_char(start_time,'mi')
and runduration<>0
order by start_time desc;
----------------------------------------- 

select lpad('=',10,'=') || 'Billing cycle performance v5' || lpad('=',10,'=') from dual;
select trunc(start_time) bc_Date, sum((end_time-start_time)*24*60*60/60) duration, sum(num_of_generated_invoices) invoices ,
sum(num_of_generated_invoices)/(sum(end_time-start_time)*24*60*60/60) invoices_per_minute
from bc_history b 
having sum(num_of_generated_invoices)>0
group by trunc(start_time)
order by trunc(start_time) desc;
-----------------------------------------

select lpad('=',10,'=') || 'FIN' || lpad('=',10,'=') from dual
; 