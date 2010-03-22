proc set_int {val} {
  if {[string is integer -strict $val]} {
    return [expr int($val)]
  } else {
    return 0
  }
}

proc run_once_command {cmd myname} {
  set ::bkp_rem_archive $myname
##get last successfull update time
  set ts_file "$::timestamp_path/$myname.timestamp"
  read_file $ts_file
  set val [set_int $::file_data]
##get our pid (if exists)
  set pid_file "$::timestamp_path/$myname.pid"
  read_file $pid_file
  set lastpid [set_int $::file_data]
  if {$lastpid != 0} {
    puts "either we are already running or we have a lost pid"
    if {[catch {exec ps -o command -p $lastpid} results]} {
      puts "ps returned an error. probably the pid doesn't exist. continue"
    } else {
      puts "pid already running with command \n$results\n. return"
      return 10
    }
  } else {
    puts "no previous process. continue"
  }

  set ::file_data [pid]
  write_file $pid_file
##check if update is needed
  if {[expr [clock seconds] - $val] > 60*$::get_period} {
    puts "\n\tneeds update\n\n"
    set ret [eval $cmd]
    if {$ret==5} {puts "\n\tTar failed on remote.";return 5}
    if {$ret == 0} {
      puts "\n\tsucces and the file is at $::local_dir/$myname"
      set ::file_data [clock seconds]
      write_file $ts_file
    } else {
      puts "\n\tCommand $cmd failed"
      return $ret
    }
  } else {
    puts "\n\tthe update period has not arived yet.\n\n"
    return 30;
  }
  file delete $pid_file
  return 0
}