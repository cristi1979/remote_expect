proc sqlplus_execute_scripts {path} {
  if {[expr [info exists $::database_ip] && [info exists $::database_user] && [info exists $::database_pass] && [info exists $::oracle_sid]]} {
    puts "\n\tERR: Not all database variables are defined: ip=$::database_ip, user=$::database_user, pass=$::database_pass, sid=$::oracle_sid."
    return 1;
  }
  set orig_prompt $::prompt

  set ret [remote_connect]
  if {$ret} {return $ret}

  set auditdir $path
  foreach script [lsort [glob -nocomplain -type f [file join  $auditdir/\[0-9\]\[0-9\]*.sql]]] {
    if {[sqlplus_launch_scripts $auditdir [file tail $script] $::database_user]}   { puts "\n\tERR: Error for script $script" }
  }

  lappend ::files_to_get { "somethingthatdoesnotexist" } 
  set ret [ssh_bkp_files_dirs_list f $::files_to_get]
  ssh_disconnect
  if {$ret==5} {return 0;}
  if {$ret} {return $ret}
  set ret [scp_get_files [lindex $::files_to_get end]]
  return $ret
}
