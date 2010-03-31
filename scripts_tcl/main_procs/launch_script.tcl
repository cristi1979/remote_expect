proc launch_script {{name ""}} {
  if {[info exists ::disabled]} {puts "\n\tDisabled flag is set. Exit now."; exit 0}
  set orig_prompt $::prompt

  set dir_name [file dirname $name]
  set file_name [file tail $name]
  if { ![file exists $name] || ![file isfile $name] || $name == ""} {
    puts "\n\tERR: File $name does not exist.";
    return 1;
  }
  
  set ret [ssh_connect]
  if {$ret} {return $ret}
  ssh_prompt
  if {[test_console]} {return 1}
  ssh_launch_cmd "mkdir -p $::bkp_rem_dir"

  if {[test_dir $::bkp_rem_dir]} {return 1}
  if {[scp_put_files "$name"]} {return 1}

  ssh_launch_cmd "cd $::bkp_rem_dir"
  ssh_launch_cmd "export STATS_OUT_DIR=$::bkp_rem_dir"
  ssh_launch_cmd "export DB_IP=$::database_ip"
  ssh_launch_background_cmd "bash $::bkp_rem_dir/$file_name"

  if {[ssh_disconnect]} {return 1}
  set ::prompt $orig_prompt
  return 0
}

proc exec_unix_statistics {} {
  set myname "$::ip\_run_unix_stats"
  set cmd [list launch_script "$::scripts_bash_dir/unix_statistics.sh"]
  return [run_once_command $cmd $myname]
}
