proc ssh_disconnect {} {
  set spawn_id $::sshid
  exp_send "exit\r"
  expect {
    eof { puts "\n\tDisconnect"; set ret 0;}
    timeout {
      puts "\n\tCould not exit. Interactive now..."
      interact
    }
    "$::orig_prompt" {
      exp_send "exit\r"
      expect ""
    }
  }
  sleep 0.2
  if {![catch {exec ps -o command -p $::sshpid} results]} {
    exec kill -9 $::sshpid
  }
  return 0;
}
