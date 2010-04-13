select lpad('=',10,'=') || 'controlfiles' || lpad('=',10,'=') from dual;
select status,name from v$controlfile;

select lpad('=',10,'=') || 'rollback' || lpad('=',10,'=') from dual;
SELECT SEGMENT_NAME,
       owner,
       a.initial_extent,
       a.next_extent,
       a.min_extents,
       a.max_extents,
       a.pct_increase,
       (select bytes / 1024 / 1024
          from dba_segments b
         where a.segment_name = b.segment_name) megs,
       a.status
  FROM DBA_ROLLBACK_SEGS a; 

select lpad('=',10,'=') || 'type' || lpad('=',10,'=') from dual;


select lpad('=',10,'=') || 'undo_retention' || lpad('=',10,'=') from dual;
select value from v$parameter where name = 'undo_retention';

select lpad('=',10,'=') || 'undotbs' || lpad('=',10,'=') from dual;
select trunc(sum(bytes) / 1024 / 1024 / 1024, 2)
  from dba_data_files t
 where t.tablespace_name = 'UNDOTBS'; 
