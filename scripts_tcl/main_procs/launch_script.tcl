proc launch_script {{name ""}} {
  if {[info exists ::disabled]} {puts "\n\tDisabled flag is set. Exit now."; return $::ERR_DISABLED}
  set orig_prompt $::prompt

  set dir_name [file dirname $name]
  set file_name [file tail $name]
  if { ![file exists $name] || ![file isfile $name] || $name == ""} {
    puts "\n\tERR: File $name does not exist.";
    return $::ERR_GENERIC;
  }
  
  set ret [ssh_connect]
  if {$ret} {return $ret}
  ssh_prompt
  if {[test_console]} {return $::ERR_GENERIC}
  ssh_launch_cmd "mkdir -p $::bkp_rem_dir"

  if {[test_dir $::bkp_rem_dir]} {ssh_disconnect; return $::ERR_GENERIC}
  if {[scp_put_files "$name"]} {ssh_disconnect; return $::ERR_GENERIC}

  ssh_launch_cmd "cd $::bkp_rem_dir"
  ssh_launch_cmd "export STATS_OUT_DIR=$::bkp_rem_dir"
  ssh_launch_cmd "export DB_IP=$::database_ip"
  ssh_launch_background_cmd "bash $::bkp_rem_dir/$file_name"

  if {[ssh_disconnect]} {return $::ERR_GENERIC}
  set ::prompt $orig_prompt
  return $::OK
}

proc exec_unix_statistics {} {
  set myname [string map {* - [ - ] - : "" / _ \\ _} $::ip\_run_unix_statistics]
  set cmd [list launch_script "$::scripts_bash_dir/unix_statistics.sh"]
  return [run_once_command $cmd $myname]
}
