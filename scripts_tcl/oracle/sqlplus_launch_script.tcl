proc sqlplus_launch_scripts {dir script {parameters [list]}} {
  set spawn_id $::sshid
  set ::sqlplus_prev_prompt $::prompt
  set ret 0

  regsub -all {[ \r\t\n]+} $script "" remote_name
  set output_file "$::bkp_rem_dir/oracle-$remote_name.out"
  set remote_script "$::bkp_rem_dir/oracle-$remote_name.sql"

  set connect_data "WHENEVER SQLERROR EXIT SQL.SQLCODE;
WHENEVER OSERROR  EXIT -1;
connect $::database_user/$::database_pass@\'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$::database_ip)(PORT=$::oracle_port))(CONNECT_DATA=(SID=$::oracle_sid)))\'"
  set ret [read_file "$dir/../begin.sql"]
  set begin_data $::file_data
  set ret [expr [read_file "$dir/$script"] + $ret]
  set scr_data $::file_data
  set ret [expr [read_file "$dir/../end.sql"] + $ret]
  set end_data $::file_data
  set ret [expr [test_console] + $ret]
  if {$ret} {return $ret}

  ssh_writefileremote $remote_script [list $connect_data $begin_data $scr_data $end_data]

  set crt_timeout $::timeout
  set ::timeout 600 
  exp_send "rm $output_file; sqlplus -S /nolog  @$remote_script $output_file $parameters \r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret 1 }
    -re "\r\nSP2-\[0-9\].*" { 
      puts "\n\tERR: sqlplus error."
      exp_send "quit\r"; 
      set ret 3
     }
    "bash: sqlplus: command not found" { puts "\n\tERR: Can't find sqlplus."; set ret 1 }
    "$::prompt" { puts "\n\tMSG: Script finished executing."; set ret 0 }
  }
  set ::timeout $crt_timeout

  if {$ret} {return $ret}
  set ret [ssh_get_lasterror]
  if {$ret} {
    puts "\n\tERR: Last error from sql script was: $ret."
  } else {
    lappend ::files_to_get "$output_file" "$remote_script"
  }

  return $ret; 
}
