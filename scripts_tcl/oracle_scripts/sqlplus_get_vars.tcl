proc sqlplus_get_vars {} {
  set orig_prompt $::prompt
  set ret [ssh_connect[
  if {$ret} {return $ret}
  ssh_prompt
  sqlplus_connect
  
  sqlplus_begin
  sqlplus_launch_command "SELECT * from voipcdr where rownum<=1" "voipcdr"
  sqlplus_launch_command "SELECT value FROM v\$parameter WHERE name = 'background_dump_dest'"
  puts "\n\n=========================== output"
  puts $::saved_output
  puts "\n\n==========================="
  sqlplus_disconnect
  sqlplus_launch_scripts "01_sql_ltom.sql"
  sqlplus_launch_scripts "01_sql_perfstat.sql"
  #ssh_launch_cmd "cat /tmp/mindcti/oracle-voipcdr.out"
  lappend ::files_to_get { "somethingthatdoesnotexist" } 
  set ::bkp_rem_archive "oracle"
  set ret [ssh_bkp_files_dirs_list f $::files_to_get]
  ssh_disconnect
  if {$ret==5} {return 0;}
  if {$ret} {return $ret} 
  puts "\n\tMSG: $::files_to_get"
  set ret [scp_get_files [lindex $::files_to_get end]]
  return $ret
} 