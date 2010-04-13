proc get_system_audit {} {
  set myname "$::ip\_system_audit"
  set ::bkp_rem_archive $myname
  return [run_once_command [list sqlplus_execute_scripts "$::scripts_sql_dir/system-audit/"] $myname]
}
