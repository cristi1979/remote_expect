proc set_int {val} {
  if {[string is integer -strict $val]} {
    return [expr int($val)]
  } else {
    return 0
  }
}

proc run_once_command {cmd myname} {
  set ret $::OK
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
    puts "MSG: either we are already running or we have a lost pid"
    if {[catch {exec "ps -o pid,command -p $lastpid"} results]} {
      puts "MSG: ps returned an error. Probably the pid doesn't exist. Continue"
    } else {
      puts "ERR: pid already running with command \n$results\n. return"
      return $::ERR_ALREADY_RUNNING
    }
  } else {
    puts "no previous process. continue"
  }

  set ::file_data [pid]
  write_file $pid_file
##check if update is needed
  if {[expr {[clock seconds] - $val}] > 60 * $::get_period} {
    puts "\n\tMSG: needs update\n\n"
    set ret [eval $cmd]
    if {$ret == $::OK || $ret==$::ERR_ZERO_SIZE} {
      puts "\n\tMSG: Command $cmd terminated successfully."
      set ::file_data [clock seconds]
      write_file $ts_file
    } else {
      puts "\n\tERR: Command $cmd failed"
    }
  } else {
    puts "\n\tERR: the update period has not arived yet.\n\n"
    set ret $::ERR_NOT_YET;
  }
  file delete $pid_file

  return $ret
}