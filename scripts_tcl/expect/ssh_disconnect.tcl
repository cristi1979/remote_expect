proc ssh_disconnect {} {
  set spawn_id $::sshid
  exp_send "exit\r"
  expect {
    eof { puts "\n\tMSG: Disconnect";}
    timeout {
      puts "\n\tERR: Could not exit."
      exp_send "exit\r"
    }
    "$::orig_prompt" {
      exp_send "exit\rexit\r"
      exp_continue
    }
  }
  sleep 0.2
  if {![catch {exec ps -o command -p $::sshpid} results]} {
    exec kill -9 $::sshpid
  }
  return 0;
}
