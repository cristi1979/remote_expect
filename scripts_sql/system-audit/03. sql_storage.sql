-----------------------------------------for partitions result
define outputfile=&1\_partitions_res.sql;
set markup HTML off;
spool &outputfile;
select 'WHENEVER SQLERROR EXIT SQL.SQLCODE' from dual;
select 'WHENEVER OSERROR  EXIT -1' from dual;
select (select 'select max (' || column_name || ') from ' || name || ';'
          from user_part_key_columns
         where object_type = 'TABLE'
           and name = a.table_name)
  from (select u.table_name,
               u.TABLE_NAME ||
               min(to_number(substr(substr(partition_name,
                                           instr(partition_name, table_name)),
                                    length(table_name) + 1))) First_partition,
               u.TABLE_NAME ||
               max(to_number(substr(substr(partition_name,
                                           instr(partition_name, table_name)),
                                    length(table_name) + 1))) Last_partition
          from user_tab_partitions u
         group by u.table_name) A,
       (select distinct (u.table_name), u.tablespace_name
          from user_tab_partitions u) B
 where a.table_name = b.table_name; 
spool &1;
set markup HTML on;
-----------------------------------------
-----------------------------------------


select lpad('=',10,'=') || 'Disk' || lpad('=',10,'=') from dual;
-----------------------------------------

select lpad('=',10,'=') || 'tablespace_data' || lpad('=',10,'=') from dual;
select (select decode(extent_management,'LOCAL','*',' ') ||
               decode(segment_space_management,'AUTO','a ','m ')
          from dba_tablespaces where tablespace_name = b.tablespace_name) ||
nvl(b.tablespace_name,
             nvl(a.tablespace_name,'UNKOWN')) name,
       kbytes_alloc mbytes,
       kbytes_alloc-nvl(kbytes_free,0) used,
       nvl(kbytes_free,0) free,
       trunc(((kbytes_alloc-nvl(kbytes_free,0))/
                          kbytes_alloc)*100,2) pct_used,
       nvl(largest,0) largest,
       nvl(kbytes_max,kbytes_alloc) Max_Size,
       decode( kbytes_max, 0, 0, (kbytes_alloc/kbytes_max)*100) pct_max_used
from ( select sum(bytes)/1024/1024 Kbytes_free,
              max(bytes)/1024/1024 largest,
              tablespace_name
       from  sys.dba_free_space
       group by tablespace_name ) a,
     ( select sum(bytes)/1024/1024 Kbytes_alloc,
              sum(maxbytes)/1024/1024 Kbytes_max,
              tablespace_name
       from sys.dba_data_files
       group by tablespace_name
       union all
      select sum(bytes)/1024/1024 Kbytes_alloc,
              sum(maxbytes)/1024/1024 Kbytes_max,
              tablespace_name
       from sys.dba_temp_files
       group by tablespace_name )b
where a.tablespace_name (+) = b.tablespace_name
order by "PCT_USED";  
-----------------------------------------

select lpad('=',10,'=') || 'Autoextensible_datafiles' || lpad('=',10,'=') from dual;
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
 group by t.tablespace_name
-----------------------------------------

select lpad('=',10,'=') || 'partitions' || lpad('=',10,'=') from dual;
select a.table_name,
       a.First_partition,
       a.Last_partition,
       b.tablespace_name,
       (select '(select max (' || column_name || ') from ' || name || ');'
          from user_part_key_columns
         where object_type = 'TABLE'
           and name = a.table_name)
  from (select u.table_name,
               u.TABLE_NAME ||
               min(to_number(substr(substr(partition_name,
                                           instr(partition_name, table_name)),
                                    length(table_name) + 1))) First_partition,
               u.TABLE_NAME ||
               max(to_number(substr(substr(partition_name,
                                           instr(partition_name, table_name)),
                                    length(table_name) + 1))) Last_partition
          from user_tab_partitions u
         group by u.table_name) A,
       (select distinct (u.table_name), u.tablespace_name
          from user_tab_partitions u) B
 where a.table_name = b.table_name; 

select lpad('=',10,'=') || 'partitions_res' || lpad('=',10,'=') from dual;
@&outputfile;
-----------------------------------------

select lpad('=',10,'=') || 'Data_file_physical_distribution' || lpad('=',10,'=') from dual;
select decode(substr(file_name, 0, 1),
              '/',
              substr(file_name, 0, 4),
              substr(file_name, 0, 3)),
       count(*)
  from dba_data_files d
 group by decode(substr(file_name, 0, 1),
                 '/',
                 substr(file_name, 0, 4),
                 substr(file_name, 0, 3));
-----------------------------------------

select lpad('=',10,'=') || 'Log_sizes' || lpad('=',10,'=') from dual;
select lpad('=',10,'=') || 'alert_BILL.log' || lpad('=',10,'=') from dual;
select lpad('=',10,'=') || 'Listener.log' || lpad('=',10,'=') from dual;
-----------------------------------------

select lpad('=',10,'=') || 'FIN' || lpad('=',10,'=') from dual;
