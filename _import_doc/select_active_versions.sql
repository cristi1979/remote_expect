set echo off;
SET FEEDBACK OFF;
SET HEADING OFF;
SET PAGESIZE 0;
SET COLSEP &1;
set pages 0 feed OFF;
set line 32767;
set TERMOUT OFF;
SET trimspool on;
set verify off;
WHENEVER SQLERROR EXIT SQL.SQLCODE;
WHENEVER OSERROR  EXIT -1;
spool &2; 

select DECODE(substr(f.vc_path, 1, 4),
              'Cust',
              concat(Substr(f.vc_path, instr(f.vc_path, '/', -1) + 2, 4),
                     Substr(f.vc_path, instr(f.vc_path, '/', -1))),
              f.vc_path) AS "MAIN Version",
       f.vc_path AS "Version", 
       concat('&3/',
              f.vc_path) AS "SVN Path"
  from sc_versions_folders f
 where f.active = 'Y'
   and f.projectcode = 'B'
 order by DECODE(substr(f.vc_path, 1, 4),
                 'Cust',
                 concat(Substr(f.vc_path, instr(f.vc_path, '/', -1) + 2, 4),
                        Substr(f.vc_path, instr(f.vc_path, '/', -1))),
                 f.vc_path),
          f.vc_path;

spool off;
set markup HTML off;
exit 
