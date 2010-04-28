proc test_console {} {
  set spawn_id $::sshid
  set ret $::ERR_IMPOSSIBLE

  exp_send "\r";
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF}
    timeout { puts "\n\tERR: Could not test console. Return error.."; set ret $::ERR_TIMEOUT }
    "\r\n$::prompt" {
      #puts "\n\tMSG: We have a console. Joy.";
      set ret  $::OK
    }
  }
  return $ret;
}
