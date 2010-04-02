proc ssh_guess_prompt {} {
  set spawn_id $::sshid
  set crt_timeout $::timeout
  set ::timeout 5
  set ret 0;
  set output [list]
  set tries 0
  set totaltries 0
  set prompt1 ""
  set prompt2 ""

  puts "\n\tMSG: trying to guess the prompt."
  exp_send "\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { 
      if {$tries == 1} {
	if {$prompt1 == ""} { 
	  set prompt1 [string trimright [lindex $output end] "\r\n"]
	  puts "\n\tMSG: Set prompt1 to \n__\n\t\t\"$prompt1\"\n__."
	} else {
	  set prompt2 [string trimright [lindex $output end] "\r\n"]
	  puts "\n\tMSG: Set prompt2 to \n__\n\t\t\"$prompt2\"\n__."
	}
	if {$prompt1 == ""} { 
	  set tries 0
	  puts "\n\tMSG: Nothing yet. Retrying."
	  exp_continue 
	}
	if {$prompt1 != $prompt2 && $prompt2 !- ""} { 
	  set tries 0
	  puts "\n\tMSG: Not sure about the prompt yet. Retrying."
	  set prompt1 ""
	  set prompt2 ""
	  exp_continue 
	}
	set ::prompt [string_asis $prompt1]

	puts "\n\tMSG: Second timeout. We presume we have now the prompt: \n\t __\"$::prompt\n___"
	set ret [test_console]
	if {!$ret} {
	  puts "\n\tMSG: Prompt found: \n\t___$::prompt ___."
	  exp_send "\r";
	} else {
	  incr tries
	  incr totaltries
	  exp_continue 
	}
      } elseif { $tries > 1 && $totaltries > 10 } {
	puts "\n\tERR: Can't guess prompt. Try to force our own prompt."
	set ::timeout $crt_timeout
	set ret [ssh_prompt]
	exp_send "\r" 
      } else {
	incr tries
	incr totaltries
	exp_send "\r";
	exp_continue 
      }
    }
    -re "(.*)\n" { lappend output $expect_out(buffer);exp_continue }
  }

  return $ret;
}
