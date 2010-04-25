select lpad('=',10,'=') || 'Applications' || lpad('=',10,'=') from dual;
select * from modulesversion
where moduleversion like (select '%' || version || '%' from ibdbver)
order by machinecode;
-----------------------------------------

select lpad('=',10,'=') || 'FIN' || lpad('=',10,'=') from dual;
