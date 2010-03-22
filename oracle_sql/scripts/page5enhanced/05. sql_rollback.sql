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
