proc sqlplus_execute_scripts {path} {
  if {[expr [info exists $::database_ip] && [info exists $::database_user] && [info exists $::database_pass] && [info exists $::oracle_sid]]} {
    puts "\n\tERR: Not all database variables are defined: ip=$::database_ip, user=$::database_user, pass=$::database_pass, sid=$::oracle_sid."
    return $::ERR_GENERIC;
  }
  set orig_prompt $::prompt

  set ret [remote_connect]
  if {$ret} {ssh_disconnect; return $ret}

  set auditdir $path
  foreach script [lsort [glob -nocomplain -type f [file join  $auditdir/\[0-9\]\[0-9\]*.sql]]] {
    set ret [sqlplus_launch_scripts $auditdir [file tail $script] $::database_user]
    if {$ret} { puts "\n\tERR: Error for script $script." }
    if {$ret==$::ERR_NO_SQLPLUS} { puts "\n\tERR: No sqlplus."; break }
    if {$ret==$::ERR_TIMEOUT} { puts "\n\tERR: Timeout."; break }
  }

  lappend ::files_to_get $::impossible_file
  if {!$ret} { set ret [ssh_bkp_files_dirs_list l $::files_to_get] }
  ssh_disconnect
  if {$ret==$::ERR_ZERO_SIZE || $ret==$::ERR_NO_SQLPLUS} {return $::OK;}
  if {$ret} {return $ret}
  set ret [scp_get_files [lindex $::files_to_get end]]
  return $ret
}
