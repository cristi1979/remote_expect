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
