proc name {} {
  global user pass ip prompt sshid
  set spawn_id $sshid
  exp_send "command\r"
  expect {
    eof {}
    timeout {
      puts "\n\tTimeout. Return error."
      return 1
    }
    "$::prompt" {
      puts "\n\tSuccess."
    }
  }
  return 0
}
