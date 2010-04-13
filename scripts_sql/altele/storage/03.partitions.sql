spool off;
define outputfile=&1;

spool intermediat_select.sql;
select (select 'select max (' || column_name || ') from ' || name
          from user_part_key_columns
         where object_type = 'TABLE'
           and name = a.table_name)
  into :coco
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
         group by u.table_name) A;
select "==========" from dual;
spool off;

spool outputfile;
@intermediat_select.sql;
select a.table_name,
       a.First_partition,
       a.Last_partition,
       b.tablespace_name,
       (select 'select max (' || column_name || ') from ' || name
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
