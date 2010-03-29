proc ls {} {
  set spawn_id $::sshid
  exp_send "ls -lart ./\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout {
      puts "\n\tERR: Timeout. Return error."
      set ret 1
    }
    "\r\n$::prompt" {
      puts "\n\tMSG: Success."
      set ret 0
    }
  }
  return $ret
}
