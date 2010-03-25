proc test_console {} {
  set spawn_id $::sshid
  exp_send "echo coco\r";
  set ret 1
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1}
    timeout { puts "\n\tCould not test console. Exit."; set ret 1 }
    "coco\r\n\r\n$::prompt" {
      puts "\n\tWe have a console. Joy.";
      set ret  0
    }
  }
  return $ret;
}
