select t.tablespace_name,
       ceil(sum(f.maxbytes) / 1024 / 1024 / 1024) as max_gigs,
       (select count(file_name)
          from dba_data_files
         where autoextensible = 'YES'
           and tablespace_name = t.tablespace_name) autoext_files,
       count(f.file_name) total_files
  from dba_tablespaces t
  left outer join dba_data_files f on t.tablespace_name = f.tablespace_name
  where t.tablespace_name not like '%TEMP%'
 group by t.tablespace_name;
