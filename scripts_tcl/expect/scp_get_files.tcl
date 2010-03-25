proc scp_get_files {files} {
  spawn scp -r $::user@$::ip:[join $files] $::local_dir

  expect {
    eof {puts "\n\tEOF. Exit."; set ret 1}
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

  catch {exp_send -i $spawn_id "$::pass\r"} res
  if {$res=="send: invalid spawn id (4)"} { return 1 }
  expect {
    eof {puts "\n\tEOF.";set ret 0}
    timeout { puts "\n\tCould not connect. Exit."; set ret 21 }
    "Permission denied, please try again." {
      puts "\n\tWrong username or password."
      set ret 1;
    }
  }
  return $ret
}
