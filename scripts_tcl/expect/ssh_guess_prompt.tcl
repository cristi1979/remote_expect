proc ssh_guess_prompt {} {
  set spawn_id $::sshid
  set crt_timeout $::timeout
  set ::timeout 1
  set ret $::OK;
  set output [list]
  set totaltries 0
  set prompt1 ""
  set prompt2 ""

  puts "\n\tMSG: trying to guess the prompt."
  exp_send "\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
    timeout { 
      if {$totaltries>=10} {
	puts "\n\tERR: Can't guess prompt. Try to force our own prompt."
	set ::timeout $crt_timeout
	set ret [ssh_prompt]
      } else {
	## continue if not output yet
	set clean_output [string trimright [lindex $output end] "\r\n"]
	if {$clean_output==""} {
	  puts "\n\tMSG: Nothing yet."
	  incr totaltries
	  exp_send "\r";
	  exp_continue
	} else {
	  ## set the prompt
	  if {$prompt1 == ""} { 
	    set prompt1 $clean_output
	    puts "\n\tMSG: Set prompt1 to \n__\n\t\t\"$prompt1\"\n__."
	    exp_send "\r";
	    exp_continue 
	  } else {
	    set prompt2 $clean_output
	    puts "\n\tMSG: Set prompt2 to \n__\n\t\t\"$prompt2\"\n__."
	    ##if we have both prompts, they need to be the same
	    if {$prompt1 != $prompt2} { 
	      incr totaltries
	      puts "\n\tMSG: Not sure about the prompt yet. Retrying."
	      set prompt1 ""
	      set prompt2 ""
	      exp_send "\r";
	      exp_continue 
	    } else {
	      set ::prompt [string_asis $prompt1]

	      puts "\n\tMSG: Second timeout. We presume we have now the prompt: \n\t __\"$::prompt\n___"
	      set ret [test_console]
	      if {!$ret} {
		puts "\n\tMSG: Prompt found: \n\t___$::prompt ___."
	      } else {
		incr tries
		incr totaltries
		exp_continue 
	      }
	    }
	  }
	}
      }
    }
    "Permission denied, please try again.\r" {puts "\n\tERR: Wrong username or password."; set ret $::ERR_WRONG_USER_PASS}
    "$::user@$::ip's password: " {puts "\n\tERR: Wrong username or password."; set ret $::ERR_WRONG_USER_PASS}
    "Password: " {puts "\n\tERR: Wrong username or password."; set ret $::ERR_WRONG_USER_PASS}
    -re "(.*)\n" { lappend output $expect_out(buffer); exp_continue }
  }
  set ::timeout $crt_timeout
  return $ret;
}
