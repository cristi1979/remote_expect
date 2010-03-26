proc ssh_guess_prompt {} {
  set spawn_id $::sshid
  set crt_timeout $::timeout
  set ::timeout 5
  set ret 0;
  set output [list]
  set tries 0

  exp_send ""
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { 
      if {$tries==1} {
	set ::prompt [string trimright [lindex $output end] "\r\n"]
	puts "\n\tSecond timeout. We presume we have now the prompt: \"$::prompt\"";
	set ret [test_console]
	if {!$ret} {
	  puts "\n\tPrompt found."
	  exp_send "\r";
	} else {
	  incr tries
	  exp_continue 
	}
      } else {
	if {$tries>1} {
	  puts "\n\tCan't guess prompt. Try to force our own prompt."
	  ssh_prompt; 	
	  exp_send "\r" 
	} else {
	  incr tries
	  exp_send "\r";
	  exp_continue 
	}
      }
    }
    -re "(.*)\n" {
      lappend output $expect_out(buffer);exp_continue
    }
  }
  return $ret;

}
