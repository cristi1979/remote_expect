proc ssh_connect {} {
  set ::sshpid [spawn ssh $::user@$::ip]
  set ::sshid $spawn_id

  set ret 2;
  expect {
    eof {  puts "\n\tERR: EOF. Unusual"; set ret 1  }
    timeout { puts "\n\tERR: Could not send user/pass. Exit."; set ret 20 }
    "*Are you sure you want to continue connecting (yes/no)? $" {
      puts "\n\tMSG: First time login."
      exp_send "yes\r"
      exp_continue
    }
    "$::user@$::ip's password: " {
      puts "\n\tMSG: Logging in."
      set ret 0
    }
    "Password: " {
      puts "\n\tMSG: Logging in."
      set ret 0
    }
  }
  if {$ret} {return $ret}
  catch {exp_send -i $spawn_id "$::pass\r"} res
  if {$res=="send: invalid spawn id (4)"} { puts "\n\tERR: No connection. Exit."; return 1 }

  if {$::extra_exp != ""} {
    expect {
      eof {  puts "\n\tERR: EOF. Unusual"; set ret 1  }
      timeout { puts "\n\tERR: Could not send extra step. Exit."; set ret 1 }
      "$::extra_exp" {
	exp_send "$::extra_send\r\r"
	puts "\n\tMSG: Extra step: $::extra_send"
	set ret 0
      }
    }
  }
  if {$ret} {return $ret}
  if { $::prompt==$::impossibleprompt } { ssh_guess_prompt }

  puts "\n\tMSG: Searching for prompt \"$::prompt\""
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Could not connect. Exit."; set ret 21 }
    "Permission denied, please try again." {
      puts "\n\tERR: Wrong username or password."
      set ret 40;
    }
    "\r\n$::prompt" { puts "\n\tMSG: Loged in."; set ret 0 }
  }

  return $ret;
}
