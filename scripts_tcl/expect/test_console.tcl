proc test_console {} {
  set spawn_id $::sshid
  set ret 1

  exp_send "echo coco\r";
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1}
    timeout { puts "\n\tCould not test console. Exit."; set ret 1 }
    "coco\r\n$::prompt" {
      puts "\n\tWe have a console. Joy.";
      set ret  0
    }
  }
  return $ret;
}
