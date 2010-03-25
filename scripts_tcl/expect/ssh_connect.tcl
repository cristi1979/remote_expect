proc ssh_connect {} {
  set ::sshpid [spawn ssh $::user@$::ip]
  set ::sshid $spawn_id

  set ret 2;
  expect {
    eof {  puts "\n\tEOF. Unusual"; set ret 1  }
    timeout { puts "\n\tCould not send user/pass. Exit."; set ret 20 }
    "*Are you sure you want to continue connecting (yes/no)? $" {
      puts "\n\tFirst time login."
      exp_send "yes\r"
      exp_continue
    }
    "$::user@$::ip's password: " {
      puts "\n\tLogging in."
      set ret 0
    }
    "Password: " {
      puts "\n\tLogging in."
      set ret 0
    }
  }
  if {$ret} {return $ret}
  catch {exp_send -i $spawn_id "$::pass\r"} res
  if {$res=="send: invalid spawn id (4)"} { puts "No connection. Exit."; return 1 }

  if {$::extra_exp != ""} {
    expect {
      eof {  puts "\n\tEOF. Unusual"; set ret 1  }
      timeout { puts "\n\tCould not send extra step. Exit."; set ret 1 }
      "$::extra_exp" {
	exp_send "$::extra_send\r\r"
	puts "\n\tExtra step."
	set ret 0
      }
    }
  }
  if {$ret} {return $ret}
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { puts "\n\tCould not connect. Exit."; set ret 21 }
    "Permission denied, please try again." {
      puts "\n\tWrong username or password."
      set ret 40;
    }
    "$::prompt" { puts "\n\tLoged in."; set ret 0 }
  }

  return $ret;
}
