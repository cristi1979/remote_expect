proc ssh_guess_prompt {} {
  set spawn_id $::sshid
  set crt_timeout $::timeout
  set ::timeout 5
  set ret 0;
  set output [list]
  set tries 0

  puts "\n\tMSG: trying to guess the prompt."
  exp_send "\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { 
      if {$tries==1} {
	set ::prompt [string trimright [lindex $output end] "\r\n"]
	puts "\n\tMSG: Second timeout. We presume we have now the prompt: \"$::prompt\"";
	set ret [test_console]
	if {!$ret} {
	  puts "\n\tMSG: Prompt found: $::prompt."
	  exp_send "\r";
	} else {
	  incr tries
	  exp_continue 
	}
      } elseif {$tries>1} {
	puts "\n\tERR: Can't guess prompt. Try to force our own prompt."
	ssh_prompt; 	
	exp_send "\r" 
      } else {
	incr tries
	exp_send "\r";
	exp_continue 
      }
    }
    -re "(.*)\n" {
      lappend output $expect_out(buffer);exp_continue
    }
  }
  set ::timeout $crt_timeout
  return $ret;

}
