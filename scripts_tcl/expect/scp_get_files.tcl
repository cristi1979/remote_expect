proc scp_get_files {files} {
  spawn scp -r $::user@$::ip:[join $files " "] $::local_dir
  set nr_times 0
  set crt_timeout $::timeout
  set ::timeout $::long_timeout

  expect {
    eof {puts "\n\tERR: EOF. Exit."; set ret 1}
    timeout { 
      if {$nr_times < 5} {
	puts "\n\tERR: Could not send user/pass. Waiting and retrying..."; 
	incr nr_times
	set ::timeout [expr {$::timeout * $nr_times}]
	exp_continue
      } else {
	puts "\n\tERR: Could not send user/pass. Exit"; 
	set ret 20 
      }
    }
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
  if {$res == "send: invalid spawn id (4)"} { return 1 }
  expect {
    eof {puts "\n\tMSG: EOF.";set ret 0}
    timeout { 
      if {$nr_times < 5} {
	puts "\n\tERR: Could not connect. Waiting and retrying..."
	incr nr_times
	set ::timeout [expr {$::timeout * $nr_times}]
	exp_continue
      } else {
	puts "\n\tERR: Could not connect. Exit."
	set ret 21 
      }
    }
    "Permission denied, please try again." {
      puts "\n\tERR: Wrong username or password."
      set ret 1;
    }
  }
  return $ret
}
