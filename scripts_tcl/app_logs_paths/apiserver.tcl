proc apiserver {{app_dir "/home/mind/mindcti/apiserver"}} {
  set myname [lindex [info level 0] 0]

  set reg [logs_regular_expresions $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "APIExceptions"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "APIErrors"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "XMLAPIInfo"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "APIInfo"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "APIStatistics"] [list $myname $reg]
}
