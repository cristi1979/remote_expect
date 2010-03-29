proc ssh_get_lasterror {} {
  set spawn_id $::sshid
  ssh_launch_cmd "echo $?"
  return [string trimright [lindex $::saved_output end] "\r\n"]
}
