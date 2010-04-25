proc sqlplus_connect {} {
  set spawn_id $::sshid
  set ret 0;
#sqlplus -S mind/mind@"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=10.1.56.65)(PORT=1521))(CONNECT_DATA=(SID=BILL)))" @/tmp/mindcti/oracle-01.sql_database_info.sql.sql /tmp/mindcti/oracle-01.sql_database_info.sql.out mind
  set ::sqlplus_prev_prompt $::prompt
  exp_send "sqlplus /nolog\r"
  set ::prompt "SQL> "
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Timeout. Could not connect to oracle."; set ret 1 }
    "bash: sqlplus: command not found" { puts "\n\tERR: Can't find sqlplus."; set ret 1 }
    "$::sqlplus_prev_prompt" {puts "\n\tERR: Could not connect to sql."; set ret 1}
    "$::prompt" {
      puts "\n\tMSG: Sqlplus open."
      set ret 0
    }
  }
  if {$ret} {return $ret}

  if {[sqlplus_launch_command "WHENEVER SQLERROR EXIT SQL.SQLCODE;"] || [sqlplus_launch_command "WHENEVER OSERROR  EXIT -1;"]} {
    return 1;
  }

  exp_send "connect $::database_user/$::database_pass@\'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$::database_ip)(PORT=$::oracle_port))(CONNECT_DATA=(SID=$::oracle_sid)))\';\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Timeout. Could not connect to oracle."; set ret 1 }
    "bash: sqlplus: command not found" { puts "\n\tERR: Can't find sqlplus."; set ret 1 }
    "$::sqlplus_prev_prompt" {puts "\n\tERR: Could not connect to sql."; set ret 1}
    "Connected.\r\n$::prompt" {
      puts "\n\tMSG: Connected to sqlplus."
      set ret 0
    }
  }
  return $ret; 
}
