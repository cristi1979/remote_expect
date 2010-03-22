select avg(x.first_time - y.first_time) * 24 * 3600
  from v$log_history x, v$log_history y
 where x.recid - 1 = y.recid
   and trunc(x.first_time) > trunc(sysdate) - 30
 order by x.first_time desc;
select min(x.first_time - y.first_time) * 24 * 3600
  from v$log_history x, v$log_history y
 where x.recid - 1 = y.recid
   and trunc(x.first_time) > trunc(sysdate) - 30
 order by x.first_time desc;
