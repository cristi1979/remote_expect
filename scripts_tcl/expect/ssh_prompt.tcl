proc ssh_prompt {} {
  set spawn_id $::sshid
  set ::orig_prompt $::prompt;
  set ret 2;

  set ::prompt "$::new_prompt"
  exp_send "bash\rexport PS1=\"$::new_prompt\"\rexport PROMPT_COMMAND=\"\"\rLC_ALL=en_US\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret 1 }
    "\r\n$::prompt" {
      set ret [test_console]
      if {!$ret} {puts "\n\tMSG: New prompt set."}
    }
  }
  return $ret;
}

