proc sqlplus_disconnect {} {
  set spawn_id $::sshid
  exp_send "quit\r"
  set ::prompt $::sqlplus_prev_prompt
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; return 1 } 
    timeout { puts "\n\tERR: Could not disconnect."; return 1 }
    "$::prompt" { puts "\n\tMSG: Disconnected from sqlplus."; return 0 }
  }
  return 1;
}
