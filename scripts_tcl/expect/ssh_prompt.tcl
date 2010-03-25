proc ssh_prompt {} {
  set spawn_id $::sshid
  set ::orig_prompt $::prompt;
  exp_send "bash\r"
  set ret 2;
  #don't care, first thing should be prompt
  expect -indices -re "(.*)\n"
  exp_send "PS1=\"$::new_prompt\"\r"
  set ::prompt $::new_prompt
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { puts "\n\tTimeout. Return error."; set ret 1 }
    "$::prompt" {
      #set ::prompt "$::new_prompt"
      set ret [test_console]
      if {!$ret} {puts "\n\tNew prompt set."}
    }
  }
  return $ret;
}

