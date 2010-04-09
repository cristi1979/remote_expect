proc launch_sqlplus {} {
  set orig_prompt $::prompt

  set ret [remote_connect]
  if {$ret} {return $ret}

  set ret1 [ sqlplus_connect ]
  if {!$ret1} { 
    sqlplus_begin
    sqlplus_launch_command "SELECT * from voipcdr where rownum<=1" "voipcdr"
    sqlplus_launch_command "SELECT value FROM v\$parameter WHERE name = 'background_dump_dest'"
    puts "\n\n=========================== output"
    puts $::saved_output
    puts "\n\n==========================="
    sqlplus_disconnect
  } else {
    sqlplus_disconnect
  }

  set auditdir "$::scripts_sql_dir/system-audit/"
  foreach script [glob -nocomplain -type f [file join  $auditdir/\[0-9\]\[0-9\]*.sql]] {
    if {[sqlplus_launch_scripts $auditdir [file tail $script] $::database_user]}  {puts "\n\tERR: Error for script $script"}
  }

  lappend ::files_to_get { "somethingthatdoesnotexist" } 
  set ::bkp_rem_archive "oracle"
  set ret [ssh_bkp_files_dirs_list f $::files_to_get]
  ssh_disconnect
  if {$ret==5} {return 0;}
  if {$ret} {return $ret}
  set ret [scp_get_files [lindex $::files_to_get end]]
  return $ret
}
