proc apiserver {{app_dir "/home/mind/mindcti/apiserver"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "APIExceptions"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "APIErrors"] [list $myname]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "XMLAPIInfo"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "APIInfo"] [list $myname]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "APIStatistics"] [list $myname]
}
