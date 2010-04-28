proc ssh_connect {} {
  set ::sshpid [spawn ssh -C $::user@$::ip]
  set ::sshid $spawn_id

  set ret $::ERR_IMPOSSIBLE;
  expect {
    eof {  puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF  }
    timeout { puts "\n\tERR: Could not send user/pass. Exit."; set ret $::ERR_USER_PASS }
    "*Are you sure you want to continue connecting (yes/no)? $" {
      puts "\n\tMSG: First time login."
      exp_send "yes\r"
      exp_continue
    }
    "$::user@$::ip's password: " { puts "\n\tMSG: Logging in.";  set ret $::OK }
    "Password: " { puts "\n\tMSG: Logging in."; set ret $::OK }
    "\r\n$::prompt" { 
      puts "\n\tMSG: Loged in. No password was needed."; 
      set ret [test_console] 
      if {$ret} { set ret $::ERR_NOPASS }
    }
  }
  if {$ret == $::ERR_NOPASS} { return $::OK }
  if {$ret} {return $ret}
  catch {exp_send -i $spawn_id "$::pass\r"} res
  if {$res == "send: invalid spawn id (4)"} { puts "\n\tERR: No connection. Exit."; return $::ERR_GENERIC }

  if {$::extra_exp != ""} {
    expect {
      eof {  puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
      timeout { puts "\n\tERR: Could not send extra step. Exit."; set ret $::ERR_TIMEOUT }
      "Permission denied, please try again.\r" {puts "\n\tERR: Wrong username or password."; set ret $::ERR_WRONG_USER_PASS}
      "$::user@$::ip's password: " {puts "\n\tERR: Wrong username or password."; set ret $::ERR_WRONG_USER_PASS}
      "Password: " {puts "\n\tERR: Wrong username or password."; set ret $::ERR_WRONG_USER_PASS}
      "$::extra_exp" {
	exp_send "$::extra_send\r\r"
	puts "\n\tMSG: Extra step: $::extra_send"
	set ret $::OK
      }
    }
  }
  if {$ret} {return $ret}
  if { $::prompt == $::impossibleprompt } { ssh_guess_prompt }

  puts "\n\tMSG: Searching for prompt \n\"$::prompt\""
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
    timeout { puts "\n\tERR: Could not connect. Exit."; set ret $::ERR_TIMEOUT }
    "Permission denied, please try again." { puts "\n\tERR: Wrong username or password."; set ret $::ERR_WRONG_USER_PASS }
    "$::user@$::ip's password: " {puts "\n\tERR: Wrong username or password."; set ret $::ERR_WRONG_USER_PASS}
    "Password: " {puts "\n\tERR: Wrong username or password."; set ret $::ERR_WRONG_USER_PASS}
    "\r\n$::prompt" { puts "\n\tMSG: Loged in."; set ret [test_console] }
  }

  return $ret;
}
