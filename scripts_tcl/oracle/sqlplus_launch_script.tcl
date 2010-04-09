proc sqlplus_launch_scripts {dir script {parameters [list]}} {
  set spawn_id $::sshid
  set ::sqlplus_prev_prompt $::prompt
  set ret 0
  set crt_timeout $::timeout
  set ::timeout 600 

  regsub -all {[ \r\t\n]+} $script "" remote_name
  set output_file "$::bkp_rem_dir/oracle-$remote_name.out"
  set remote_script "$::bkp_rem_dir/oracle-$remote_name.sql"

  set ret [read_file "$dir/begin.sql"]
  set begin_data $::file_data
  set ret [expr [read_file "$dir/$script"] + $ret]
  set scr_data $::file_data
  set ret [expr [read_file "$dir/end.sql"] + $ret]
  set end_data $::file_data
  if {$ret} {return $ret}

  ssh_writefileremote $remote_script [list $begin_data $scr_data $end_data]

  exp_send "sqlplus -s -L \"$::database_user\"/\"$::database_pass\" @$remote_script $output_file $parameters \r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret 1 }
    -re "\r\nSP2-\[0-9\].*" { 
      puts "\n\tERR: Invalid file name."
      exp_send "quit\r"; 
      set ret 3
     }
    "bash: sqlplus: command not found" { puts "\n\tERR: Can't find sqlplus."; set ret 1 }
    "$::prompt" {
      lappend ::files_to_get "$output_file" "$remote_script";
      puts "\n\tMSG: Script finished executing."
      set ret 0
    }
  }
  set ::timeout $crt_timeout
  return $ret; 
}