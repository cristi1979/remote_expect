proc ssh_launch_background_cmd {cmd {output_file "/dev/null"} {error_file "/dev/null"}} {
  set spawn_id $::sshid
  exp_send "$cmd 1>$output_file 2>$error_file &\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret 1 }
    "\r\n$::prompt" {
      set ret 0
    }
  }
  return $ret
}

