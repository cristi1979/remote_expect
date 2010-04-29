proc bkp_app {type file_names {days ""} } {
  set orig_prompt $::prompt
  set ret [remote_connect]
  if {$ret} {
    if {$ret!=$::ERR_CANT_CONNECT && $ret!=$::ERR_WRONG_USER_PASS && $ret!=$::ERR_USER_PASS} {
      ssh_disconnect
    } 
    return $ret
  }

  set ret [ssh_bkp_files_dirs_list $type $file_names $days]
  ssh_disconnect
  set ::prompt $orig_prompt

  if { $ret && $ret!=$::ERR_ZERO_SIZE} {
    puts "\n\tERR: Something went wrong."
  } else {
    puts "\n\tMSG: Backup successfull."
    set ret [scp_get_files [join $::files_to_get]]
  }
  return $ret
}
