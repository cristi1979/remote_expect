proc sqlplus_launch_command {cmd {file ""}} {
  set ::spawn_id $::sshid
  set ret $::ERR_IMPOSSIBLE
  if {$file != ""} {
    set output_file $::bkp_rem_dir/oracle-$file.out
    exp_send "spool $output_file\;\r"
    expect {
      eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
      timeout { puts "\n\tERR: Timeout. Return error."; set ret $::ERR_TIMEOUT }
      "$::prompt" { lappend ::files_to_get "$output_file"; set ret $::OK}
    }
  } 

  if {$ret} {return $ret}
  exp_send "$cmd\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret $::ERR_TIMEOUT }
    "ERROR at line " {puts "\n\tERR: Command error"; set ret $::ERR_GENERIC}
    -re "\r\nSP2-\[0-9\].*" { puts "\n\tERR: Command error."; set ret $::ERR_SQLPLUS_ERR }
    "$::prompt" { puts "\n\tMSG: sqlplus command $cmd ended."; lappend ::saved_output $expect_out(buffer);set ret $::OK }
  }

  if {$file != ""} {
    exp_send "spool off\r"
    expect {
      eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
      timeout { puts "\n\tERR: Timeout. Return error."; set ret $::ERR_TIMEOUT }
      "$::prompt" {set ret $::OK}
    }
  } 

  return $ret; 
}
