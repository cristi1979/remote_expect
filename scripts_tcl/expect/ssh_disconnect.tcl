proc ssh_disconnect {} {
  set spawn_id $::sshid
  catch {exp_send "exit\r"} res
  if {$res == "send: invalid spawn id (4)" || $res == "can not find channel named \"0\""} { puts "\n\tERR: No connection. Exit."; return 1 }
  expect {
    eof { puts "\n\tMSG: Disconnect";}
    timeout {
      puts "\n\tERR: Could not exit."
      catch {exp_send "exit\r"} res
      if {$res == "send: invalid spawn id (4)"} { puts "\n\tERR: No connection. Exit."; return 1 } 
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
