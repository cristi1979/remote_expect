proc bkp_app {type file_names {days ""} } {
  set orig_prompt $::prompt
  set ::files_to_get [list]
  lappend ::files_to_get { "somethingthatdoesnotexist" }
  set ret [ssh_connect]
  if {$ret} {puts "\n\tERR: Can't connect.";return $ret}
  set ret [ssh_prompt]
  if {$ret} {puts "\n\tERR: Can't get new prompt.";return $ret}
  ssh_launch_cmd "mkdir -p $::bkp_rem_dir"
  if {[test_dir $::bkp_rem_dir]} {return 1}
  getOS

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
