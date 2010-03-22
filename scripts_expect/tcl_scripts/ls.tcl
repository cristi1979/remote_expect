proc ls {} {
  set spawn_id $::sshid
  exp_send "ls -lart ./\r"
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout {
      puts "\n\tTimeout. Return error."
      set ret 1
    }
    "$::prompt" {
      puts "\n\tSuccess."
      set ret 0
    }
  }
  return $ret
}
