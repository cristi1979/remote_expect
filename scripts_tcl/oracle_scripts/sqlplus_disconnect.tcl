proc sqlplus_disconnect {} {
  set spawn_id $::sshid
  exp_send "quit\r"
  set ::prompt $::sqlplus_prev_prompt
  expect {
    eof { puts "\n\tEOF. Unusual"; return 1 } 
    timeout { puts "\n\tCould not disconnect."; return 1 }
    "$::prompt" { puts "\n\tDisconnected from sqlplus."; return 0 }
  }
  return 1;
}
