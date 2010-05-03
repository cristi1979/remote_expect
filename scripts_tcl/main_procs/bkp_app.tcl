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
  } elseif {$ret==$::ERR_ZERO_SIZE} {
    puts "\n\tERR: No files to retrieve."
  } else {
    puts "\n\tMSG: Backup successfull."
    set ret1 [scp_get_files [join $::files_to_get]]
    if {$ret1} {
      puts "\n\tERR: Something went wrong with scp."
      return $ret1
    }
  }
  return $ret
}
