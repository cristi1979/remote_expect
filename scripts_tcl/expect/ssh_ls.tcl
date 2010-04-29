proc ssh_ls {} {
  set spawn_id $::sshid
  exp_send "ls -lart ./\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_GENERIC }
    timeout {
      puts "\n\tERR: Timeout. Return error."
      set ret $::ERR_GENERIC
    }
    "\r\n$::prompt" {
      puts "\n\tMSG: Success."
      set ret $::OK
    }
  }
  return $ret
}
