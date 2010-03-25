proc get_them {logstype {nr_days ""}} {
  myhash -getnode ::applications_array $logstype $::from_apps
  myhash -clean ::tmp_array
  set file_names [list]
  foreach key [array names ::tmp_array] {
    set tmp_list [split [string trim $key \"] ","]
    lappend file_names [join [lrange $tmp_list 1 [llength $tmp_list]] \/]
  }

  set myname [string map {* - [ - ] - : "" / _ \\ _} $::ip\_$logstype]
  return [run_once_command [list bkp_app $file_names $nr_days] $myname]
}

proc get_unix_statistics {{nr_days ""}} {
  set ::from_apps [list]
  return [get_them ::unix_statistics $nr_days]
}

proc get_apps_exceptions {{nr_days ""}} {
  #set ret [get_them $::str_app_exceptions $nr_days]
set ret 0
set ::bkp_rem_archive "200.52.193.222_app_exceptions"
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
