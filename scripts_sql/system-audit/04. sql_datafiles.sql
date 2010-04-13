select lpad('=',10,'=') || 'Datafiles' || lpad('=',10,'=') from dual;
select file_name, tablespace_name, trunc(bytes/1024/1024/1024,2) size_gb, status
  from dba_data_files
 order by tablespace_name, file_id;
-----------------------------------------

select lpad('=',10,'=') || 'FIN' || lpad('=',10,'=') from dual; 
