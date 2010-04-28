proc sqlplus_disconnect {} {
  set spawn_id $::sshid
  exp_send "quit\r"
  set ::prompt $::sqlplus_prev_prompt
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; return $::ERR_GENERIC } 
    timeout { puts "\n\tERR: Could not disconnect."; return $::ERR_GENERIC }
    "$::prompt" { puts "\n\tMSG: Disconnected from sqlplus."; return $::OK }
  }
  return $::ERR_GENERIC;
}
