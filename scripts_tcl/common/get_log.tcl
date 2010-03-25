proc get_them {logstype {nr_days ""}} {
  myhash -getnode ::applications_array $logstype $::from_apps
  myhash -clean ::tmp_array
  set file_names [list]
  foreach key [array names ::tmp_array] {
    set tmp_list [split [string trim $key \"] ","]
    lappend file_names [join [lrange $tmp_list 1 [llength $tmp_list]] \/]
  }

  set myname [string map {* - [ - ] - : "" / _ \\ _} $::ip\_$logstype]
  return [run_once_command [list bkp_app f $file_names $nr_days] $myname]
}

proc get_unix_statistics {{nr_days ""}} {
  set ::from_apps [list]
  return [get_them ::unix_statistics $nr_days]
}

proc get_apps_exceptions {{nr_days ""}} {
  set ret [get_them $::str_app_exceptions $nr_days]
  if {$ret} {
    return $ret
  }
  set ret [parse_exceptions]
  return $ret
}

proc get_apps_logs {{nr_days ""}} {
  return [get_them $::str_app_logs $nr_days]
}

proc get_apps_statistics {{nr_days ""}} {
  return [get_them $::str_app_statistics $nr_days]
}

proc get_apps {} {
  set app_skip [list]
  set app_dir [list]

  myhash -getnode ::applications_array $::str_app_logs $::from_apps
  myhash -clean ::tmp_array
  foreach key [array names ::tmp_array] {
    set tmp_list [split [string trim $key \"] ","]
    lappend app_dir [lindex $tmp_list 1]
    lappend app_skip [join [lrange $tmp_list 1 [llength $tmp_list]-2] \/]
  }

  myhash -getnode ::applications_array $::str_app_skipdirs $::from_apps
  myhash -clean ::tmp_array

  foreach key [array names ::tmp_array] {
    set tmp_list [split [string trim $key \"] ","]
    foreach name [lindex $tmp_list 2] {
      lappend app_skip [ join [list [lindex $tmp_list 1] [string_asis [string trim $name \"]]] \/]
    }
  }

  set ::skip_list $app_skip
  set myname [string map {* - [ - ] - : "" / _ \\ _} $::ip\_$::str_app_skipdirs]
  return [run_once_command [list bkp_app d $app_dir] $myname]
}
