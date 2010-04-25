select lpad('=',10,'=') || 'database' || lpad('=',10,'=') from dual;
select * from v$version;
-----------------------------------------

select lpad('=',10,'=') || 'options' || lpad('=',10,'=') from dual;
select * from v$option;
-----------------------------------------

select lpad('=',10,'=') || 'Spfile_implementation' || lpad('=',10,'=') from dual;
select name, value from v$parameter where name like 'spfile';
-----------------------------------------

select lpad('=',10,'=') || 'Performance monitoring' || lpad('=',10,'=') from dual;
select lpad('=',10,'=') || 'OSWatcher installed' || lpad('=',10,'=') from dual;

-----------------------------------------

select lpad('=',10,'=') || 'ltom' || lpad('=',10,'=') from dual;
select * from all_users where upper(username)='TOM';
-----------------------------------------

select lpad('=',10,'=') || 'perfstat' || lpad('=',10,'=') from dual;
select * from all_users where upper(username)='PERFSTAT';
-----------------------------------------

select lpad('=',10,'=') || 'schemas' || lpad('=',10,'=') from dual;
select lpad(' ', 2 * level) || granted_role "User, his roles and privileges"
  from (select null grantee, username granted_role
          from dba_users
         where upper(username) like upper('%&2%')
        union
        select grantee, granted_role
          from dba_role_privs
        union
        select grantee, privilege from dba_sys_privs)
 start with grantee is null
connect by grantee = prior granted_role;
-----------------------------------------

select lpad('=',10,'=') || 'stats' || lpad('=',10,'=') from dual;
select distinct package_name,object_name from all_arguments where package_name = 'IPHONEX_STATS';
select distinct package_name,object_name from sys.all_arguments where package_name = 'IPHONEX_STATS' ;
select what from dba_jobs where upper(what) like '%GATHER%';
-----------------------------------------

select lpad('=',10,'=') || 'FIN' || lpad('=',10,'=') from dual;
