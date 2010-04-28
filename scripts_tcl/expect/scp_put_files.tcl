proc scp_put_files {files} {
  if {[file readable $files]} {puts "ok"} else {puts "NOK"}
  set spawnid [spawn scp $files $::user@$::ip:$::bkp_rem_dir/]
  expect {
    eof {puts "\n\tERR: EOF. Exit."; set ret $ERR_EOF}
    timeout { puts "\n\tERR: Could not send user/pass. Exit."; set ret $::ERR_USER_PASS }
    "*Are you sure you want to continue connecting (yes/no)? $" {
      puts "\n\tMSG: First time login."
      exp_send "yes\r"
      exp_continue
    }
    "$::user@$::ip's password: " {
      puts "\n\tMSG: Logging in."
	  set ret $::OK;
    }
    "Password: " {
      puts "\n\tMSG: Logging in."
	  set ret $::OK
    }
  }
  if {$ret} {return $ret}

  catch {exp_send -i $spawn_id "$::pass\r"} res
  if {$res=="send: invalid spawn id (4)"} { return $::ERR_GENERIC}
  expect {
    eof {puts "\n\tMSG: EOF.";set ret $::OK}
    timeout { puts "\n\tERR: Could not connect. Exit."; set ret $::ERR_CANT_CONNECT }
    "Permission denied, please try again." {
      puts "\n\tERR: Wrong username or password."
      set ret $::ERR_WRONG_USER_PASS
    }
    "Resource temporarily unavailable" { puts "\n\tERR: Resource temporarily unavailable"; set ret $::ERR_GENERIC }
  }

  return $ret
}
