SELECT (sysdate - to_date('19700101', 'YYYYMMDD')) * 86400 - (max(last_analyzed) - to_date('19700101', 'YYYYMMDD')) * 86400,
       table_name,
       max(last_analyzed)
  from user_indexes
 group by table_name
 order by 1 desc;
