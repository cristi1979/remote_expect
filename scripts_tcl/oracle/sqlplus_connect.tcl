proc sqlplus_connect {} {
  set spawn_id $::sshid
  set ret $::OK;
#sqlplus -S mind/mind@"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=10.1.56.65)(PORT=1521))(CONNECT_DATA=(SID=BILL)))" @/tmp/mindcti/oracle-01.sql_database_info.sql.sql /tmp/mindcti/oracle-01.sql_database_info.sql.out mind
  set ::sqlplus_prev_prompt $::prompt
  exp_send "sqlplus /nolog\r"
  set ::prompt "SQL> "
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
    timeout { puts "\n\tERR: Timeout. Could not connect to oracle."; set ret $::ERR_TIMEOUT }
    "bash: sqlplus: command not found" { puts "\n\tERR: Can't find sqlplus."; set ret $::ERR_NO_SQLPLUS }
    "$::sqlplus_prev_prompt" {puts "\n\tERR: Could not connect to sql."; set ret $::ERR_SQLPLUS_ERR}
    "$::prompt" {
      puts "\n\tMSG: Sqlplus open."
      set ret $::OK
    }
  }
  if {$ret} {return $ret}

  if {[sqlplus_launch_command "WHENEVER SQLERROR EXIT SQL.SQLCODE;"] || [sqlplus_launch_command "WHENEVER OSERROR  EXIT -1;"]} {
    return $::ERR_GENERIC;
  }

  exp_send "connect $::database_user/$::database_pass@\'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$::database_ip)(PORT=$::oracle_port))(CONNECT_DATA=(SID=$::oracle_sid)))\';\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
    timeout { puts "\n\tERR: Timeout. Could not connect to oracle."; set ret $::ERR_TIMEOUT }
    "bash: sqlplus: command not found" { puts "\n\tERR: Can't find sqlplus."; set ret $::ERR_NO_SQLPLUS }
    "$::sqlplus_prev_prompt" {puts "\n\tERR: Could not connect to sql."; set ret $::ERR_SQLPLUS_ERR}
    "Connected.\r\n$::prompt" {
      puts "\n\tMSG: Connected to sqlplus."
      set ret $::OK
    }
  }
  return $ret; 
}
