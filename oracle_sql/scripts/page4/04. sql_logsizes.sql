select value/1024/1024 as MB from v$parameter where name='log_buffer';
select distinct bytes/1024/1024 as mb from v$log;
