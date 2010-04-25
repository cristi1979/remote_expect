select name, value
  from v$parameter
 where name in
       ('log_archive_dest', 'log_archive_start', 'log_archive_format');
