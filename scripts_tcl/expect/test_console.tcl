proc test_console {} {
  set spawn_id $::sshid
  set ret 1

  exp_send "\r";
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1}
    timeout { puts "\n\tERR: Could not test console. Return error.."; set ret 1 }
    "\r\n$::prompt" {
      puts "\n\tMSG: We have a console. Joy.";
      set ret  0
    }
  }
  return $ret;
}
