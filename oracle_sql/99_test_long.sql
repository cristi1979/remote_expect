SELECT * from voipcdr where rownum<=1;
select name, value from v$parameter where name like 'spfile';