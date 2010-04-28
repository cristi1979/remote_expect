proc ssh_get_lasterror {} {
  set spawn_id $::sshid
  ssh_launch_cmd "echo $?"
  set ret [string trimright [lindex $::saved_output end] "\r\n"]
  if {[string is integer -strict $ret]} { 
    return $ret 
  } else {
    return $::ERR_IMPOSSIBLE
  }
}
