select lpad('=',10,'=') || 'logs' || lpad('=',10,'=') from dual;
SELECT value FROM v$parameter WHERE name = 'background_dump_dest';

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
define outputfile=&1;
spool &outputfile\_partitions_res.sql;
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
spool &outputfile append;
@&outputfile\_partitions_res.sql;

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

select lpad('=',10,'=') || 'parameters' || lpad('=',10,'=') from dual;
select v.NAME, v.VALUE, v.DESCRIPTION
  from v$parameter v
 where v.NAME in
       ('processes', 'timed_statistics', 'shared_pool_size',
        'enqueue_resources', 'control_files', 'db_block_buffers',
        'db_block_size', 'compatible', 'log_buffer',
        'log_checkpoint_interval', 'db_files',
        'db_file_multiblock_read_count', 'dml_locks', 'rollback_segments',
        'remote_login_passwordfile', 'sort_area_size', 'sga_target',
        'sga_max_size', 'db_name', 'open_cursors',
        'optimizer_index_cost_adj', 'query_rewrite_enabled',
        'cursor_space_for_time', 'utl_file_dir', 'job_queue_processes',
        'job_queue_interval', 'hash_join_enabled', 'background_dump_dest',
        'user_dump_dest', 'pga_aggregate_target', 'workarea_size_policy',
        'db_cache_size', 'filesystemio_options'); 

select lpad('=',10,'=') || 'FIN' || lpad('=',10,'=') from dual; 
