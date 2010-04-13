proc bkp_app {type file_names {days ""} } {
  set orig_prompt $::prompt
  set ret [remote_connect]
  if {$ret} {return $ret}

  set ret [ssh_bkp_files_dirs_list $type $file_names $days]
  ssh_disconnect
  set ::prompt $orig_prompt

  if {$ret==5} {puts "\n\tERR: no archive";return $ret}
  if { $ret } {
    puts "\n\tERR: Something went wrong."
  } else {
    puts "\n\tMSG: Backup successfull."
    set ret [scp_get_files [join $::files_to_get]]
  }
  return $ret
}
