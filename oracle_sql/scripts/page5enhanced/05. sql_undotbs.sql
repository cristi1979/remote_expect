select trunc(sum(bytes) / 1024 / 1024 / 1024, 2)
  from dba_data_files t
 where t.tablespace_name = 'UNDOTBS';
