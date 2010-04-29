proc get_them {logstype {nr_days ""}} {
  puts "\n\n\t\t##############################################\n\t\t## MSG:Starting to work on $logstype \n\t\t##############################################\n\n"
  myhash -getnode ::applications_array $logstype $::from_apps
  myhash -clean ::tmp_array
  set file_names [list]

  foreach key [array names ::tmp_array] {
    set tmp_list [split [string trim $key \"] ","]
    set aname [join [lrange $tmp_list 1 [llength $tmp_list]] \/]
    if {[llength $::tmp_array($key)]==2} {
      set aregexp "[lindex $::tmp_array($key) 1]"
    } else {
      set aregexp $::regexpmind
    }
     lappend file_names [list $aname $aregexp]
  }
  set myname [string map {* - [ - ] - : "" / _ \\ _} $::ip\_$logstype]
  return [run_once_command [list bkp_app f $file_names $nr_days] $myname]
}

proc get_unix_statistics {{nr_days ""}} {
  set ::from_apps [list]
  unix_statistics
  set ret [get_them $::str_unix_statistics $nr_days]
  if {$ret} { return $ret }
  return [launch_parser_sh "statistics" "unix"]
}

proc get_apps_exceptions {{nr_days ""}} {
  set ret [get_them $::str_app_exceptions $nr_days]
  if {$ret} { return $ret }
  return [launch_parser_sh "exceptions"]
}

proc get_apps_logs {{nr_days ""}} {
  return [get_them $::str_app_logs $nr_days]
}

proc get_apps_statistics {{nr_days ""}} {
  set ret [get_them $::str_app_statistics $nr_days]
  if {$ret} { return $ret }
  return [launch_parser_sh "statistics" "app"]
}

proc get_apps {} {
  puts "\n\n\t\t##############################################\n\t\t## MSG:Starting to work on get applications \n\t\t##############################################\n\n"

  set app_dir [list]
  myhash -getnode ::applications_array $::str_app_logs $::from_apps
  myhash -clean ::tmp_array
  foreach key [array names ::tmp_array] {
    lappend app_dir [lindex [split [string trim $key \"] ","] 1]
  }

  set app_skip [list]
  ## add dirs to skip list
  myhash -getnode ::applications_array $::str_app_logs $::from_apps
  myhash -clean ::tmp_array
  foreach key [array names ::tmp_array] {
    set tmp_list [split [string trim $key \"] ","]
    lappend app_skip [join [lrange $tmp_list 1 [llength $tmp_list]-2] \/]
  }

  ## add rest of defined skip lists
  myhash -getnode ::applications_array $::str_app_skipdirs $::from_apps
  myhash -clean ::tmp_array
  foreach key [array names ::tmp_array] {
    set tmp_list [split [string trim $key \"] ","]
    foreach name [lindex $tmp_list 2] {
      lappend app_skip [ join [list [lindex $tmp_list 1] [string_asis [string trim $name \"]]] \/]
    }
  }

  set ::skip_list [lsort -unique $app_skip]

  set myname [string map {* - [ - ] - : "" / _ \\ _} $::ip\_apps_dirs]
  return [run_once_command [list bkp_app d [lsort -unique $app_dir]] $myname]
}

proc get_system_audit {} {
  puts "\n\n\t\t##############################################\n\t\t## MSG:Starting to work on system audit \n\t\t##############################################\n\n"
  set myname "$::ip\_system_audit"
  set ::bkp_rem_archive $myname
  return [run_once_command [list sqlplus_execute_scripts "$::scripts_sql_dir/system-audit/"] $myname]
}
