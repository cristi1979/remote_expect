proc sqlplus_launch_scripts {script {parameters [list]}} {
  set spawn_id $::sshid
  set ::sqlplus_prev_prompt $::prompt

  
  set output_file "$::bkp_rem_dir/oracle-$script.out"
  set remote_script "$::bkp_rem_dir/$script"

  if {[read_file "$::oracle_scripts_dir/begin.sql"]} {return 1;}
  set begin_data $::file_data
  if {[read_file "$::oracle_scripts_dir/$script"]} {return 1;}
  set scr_data $::file_data
  if {[read_file "$::oracle_scripts_dir/end.sql"]} {return 1;}
  set end_data $::file_data
  exp_send "cat > \"$remote_script\" << EOF_COCO_RADA
  $begin_data
  $scr_data
  $end_data\rEOF_COCO_RADA\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; return 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; return 1 }
    "$::prompt" {puts "\n\tMSG: Finish to write script on remote." }
  }
  exp_send "sqlplus -s -L \"$::database_user\"/\"$::database_pass\" @$remote_script $output_file $parameters \r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; return 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; return 1 }
    "SP2-0556: Invalid file name.\r\n" { 
      puts "\n\tERR: Invalid file name."
      exp_send "quit\r"; 
      return 3
     }
    "bash: sqlplus: command not found" { puts "\n\tERR: Can't find sqlplus."; return 1 }
    "$::prompt" {
      lappend ::files_to_get "$output_file";
      puts "\n\tMSG: Script finished executing."
      return 0
    }
  }
  return 2; 
}