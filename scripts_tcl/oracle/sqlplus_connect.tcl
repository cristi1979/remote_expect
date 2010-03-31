proc sqlplus_connect {} {
  set spawn_id $::sshid

  set ::sqlplus_prev_prompt $::prompt
  exp_send "sqlplus -L \"$::database_user\"/\"$::database_pass\"\r"
  set ::prompt "SQL> "
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; return 1 }
    timeout { puts "\n\tERR: Timeout. Could not connect to oracle."; return 1 }
    "bash: sqlplus: command not found" { puts "\n\tERR: Can't find sqlplus."; return 1 }
    "$::prompt" {
      puts "\n\tMSG: Connected to sqlplus."
      return 0
    }
  }
  return 2; 
}
