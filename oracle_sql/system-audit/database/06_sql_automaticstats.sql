select distinct package_name,object_name from all_arguments where package_name = 'IPHONEX_STATS';
select distinct package_name,object_name from sys.all_arguments where package_name = 'IPHONEX_STATS' ;
select what from dba_jobs where upper(what) like '%GATHER%';
