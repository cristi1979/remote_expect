proc ssh_prompt {} {
  set spawn_id $::sshid
  set ::orig_prompt $::prompt;
  set ret $::ERR_IMPOSSIBLE;

  set ::prompt "$::new_prompt"
  exp_send "bash --version && bash\rexport PS1=\"$::new_prompt\";export PROMPT_COMMAND=\"\" \r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret $::ERR_TIMEOUT }
    "\r\n$::prompt" {
      set ret [test_console]
      if {!$ret} {puts "\n\tMSG: New prompt set."}
    }
  }
  return $ret;
}
