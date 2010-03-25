proc ssh_launch_background_cmd {cmd {output_file "&1"} {error_file "&2"}} {
  set spawn_id $::sshid
  exp_send "$cmd 1>$output_file 2>$error_file &\r"
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { puts "\n\tTimeout. Return error."; set ret 1 }
    "$::prompt" {
      set ret 0
    }
  }
  return $ret
}

