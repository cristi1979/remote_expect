proc scp_get_files {files} {
  spawn scp -p $::user@$::ip:[join $files " "] $::local_dir
  set nr_times 0
  set crt_timeout $::timeout
  set ::timeout $::long_timeout

  expect {
    eof {puts "\n\tERR: EOF. Exit."; set ret $::ERR_EOF}
    timeout { 
      if {$nr_times < 5} {
	puts "\n\tERR: Could not send user/pass. Waiting and retrying..."; 
	incr nr_times
	set ::timeout [expr {$::timeout * $nr_times}]
	exp_continue
      } else {
	puts "\n\tERR: Could not send user/pass. Exit"; 
	set ret $::ERR_USER_PASS
      }
    }
    "*Are you sure you want to continue connecting (yes/no)? $" {
      puts "\n\tMSG: First time login."
      exp_send "yes\r"
      exp_continue
    }
    "$::user@$::ip's password: " {
      puts "\n\tMSG: Logging in."
	  set ret $::OK
    }
    "Password: " {
      puts "\n\tMSG: Logging in."
	  set ret $::OK
    }
  }
  if {$ret} {return $ret}
  catch {exp_send -i $spawn_id "$::pass\r"} res
  if {$res == "send: invalid spawn id (4)"} { return $::ERR_GENERIC }
  expect {
    eof {puts "\n\tMSG: EOF.";set ret $::OK}
    timeout { 
      if {$nr_times < 5} {
	puts "\n\tERR: Could not connect. Waiting and retrying..."
	incr nr_times
	set ::timeout [expr {$::timeout * $nr_times}]
	exp_continue
      } else {
	puts "\n\tERR: Could not connect. Exit."
	set ret $::ERR_CANT_CONNECT
      }
    }
    "Permission denied, please try again." {
      puts "\n\tERR: Wrong username or password."
      set ret $::ERR_WRONG_USER_PASS;
    }
  }
  return $ret
}
