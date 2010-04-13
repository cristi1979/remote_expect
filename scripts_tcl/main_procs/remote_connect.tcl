proc remote_connect {} {
  if {[info exists ::disabled]} {puts "\n\tDisabled flag is set. Exit now."; return 50}
  set ::files_to_get [list]
  lappend ::files_to_get { "somethingthatdoesnotexist" }
  set ret [ssh_connect]
  if {$ret} {puts "\n\tERR: Can't connect.";return $ret}
  set ret [ssh_prompt]
  if {$ret} {puts "\n\tERR: Can't get new prompt.";return $ret}
  ssh_launch_cmd "mkdir -p $::bkp_rem_dir"
  if {[test_dir $::bkp_rem_dir]} {return 1}
  getOS
}