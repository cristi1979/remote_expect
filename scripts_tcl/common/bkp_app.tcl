proc bkp_app {type file_names {days ""} } {
  set orig_prompt $::prompt
  set ::files_to_get [list]
  lappend ::files_to_get { "somethingthatdoesnotexist" }
  set ret [ssh_connect]
  if {$ret} {puts "\n\tCan't connect";return $ret}
  ssh_prompt
  ssh_launch_cmd "mkdir -p $::bkp_rem_dir"
  if {[test_dir $::bkp_rem_dir]} {return 1}
  getOS

  set ret [ssh_bkp_files_dirs_list $type $file_names $days]

  ssh_disconnect
  set ::prompt $orig_prompt

  if {$ret==5} {puts "\n\tno archive";return $ret}
  if { $ret } {
    puts "\n\tSomething went wrong."
  } else {
    puts "\n\tBackup successfull."
    set ret [scp_get_files [join $::files_to_get]]
  }
  return $ret
}
