select file_name,
       tablespace_name,
       trunc(bytes / 1024 / 1024 / 1024, 2) size_gb,
       status
  from dba_data_files
 order by tablespace_name, file_id;
