proc ssh_prompt {} {
  set spawn_id $::sshid
  set ::orig_prompt $::prompt;
  set ret 2;

  set ::prompt "$::new_prompt"
  exp_send "bash\rexport PS1=\"$::new_prompt\"\rexport PS2=\"\"\rexport PROMPT_COMMAND=\"\"\r"
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { puts "\n\tTimeout. Return error."; set ret 1 }
    "\r\n$::prompt" {
      set ret [test_console]
      if {!$ret} {puts "\n\tNew prompt set."}
    }
  }
  return $ret;
}

