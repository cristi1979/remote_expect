SELECT ts.tablespace_name,
       "File Count",
       TRUNC("SIZE(MB)", 2) "Size(MB)",
       TRUNC(fr."FREE(MB)", 2) "Free(MB)",
       TRUNC("SIZE(MB)" - "FREE(MB)", 2) "Used(MB)",
       df."MAX_EXT" "Max Ext(MB)",
       (fr."FREE(MB)" / df."SIZE(MB)") * 100 "% Free",
       RPAD('*',TRUNC(CEIL((fr."FREE(MB)" / df."SIZE(MB)") * 100) / 10),'*') "Graph"
  FROM (SELECT tablespace_name, SUM(bytes) / (1024 * 1024) "FREE(MB)"
          FROM dba_free_space
         GROUP BY tablespace_name) fr,
       (SELECT tablespace_name,
               SUM(bytes) / (1024 * 1024) "SIZE(MB)",
               COUNT(*) "File Count",
               SUM(maxbytes) / (1024 * 1024) "MAX_EXT"
          FROM dba_data_files
         GROUP BY tablespace_name) df,
       (SELECT tablespace_name FROM dba_tablespaces) ts
 WHERE fr.tablespace_name = df.tablespace_name(+)
   AND fr.tablespace_name = ts.tablespace_name(+)
 ORDER BY "% Free";
