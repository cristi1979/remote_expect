proc sqlplus_launch_command {cmd {file ""}} {
  set ::spawn_id $::sshid
  set ret 2
  if {$file != ""} {
    set output_file $::bkp_rem_dir/oracle-$file.out
    exp_send "spool $output_file\;\r"
    expect {
      eof { puts "\n\tERR: EOF. Unusual"; return 1 }
      timeout { puts "\n\tERR: Timeout. Return error."; return 1 }
      "$::prompt" { lappend ::files_to_get "$output_file";}
    }
  } 

  exp_send "$cmd\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; return 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; return 1 }
    "ERROR at line " {puts "\n\tERR: Command error"; set ret 1}
    -re "\r\nSP2-\[0-9\].*" { puts "\n\tERR: Command error."; return 1 }
    "$::prompt" { puts "\n\tMSG: sqlplus command $cmd ended."; lappend ::saved_output $expect_out(buffer);set ret 0 }
  }

  if {$file != ""} {
    exp_send "spool off\r"
    expect {
      eof { puts "\n\tERR: EOF. Unusual"; return 1 }
      timeout { puts "\n\tERR: Timeout. Return error."; return 1 }
      "$::prompt" {}
    }
  } 

  return $ret; 
}
