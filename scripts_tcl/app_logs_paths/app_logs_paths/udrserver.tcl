proc udrserver {{app_dir "/home/mind/mindcti/udr"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "UDRDist-Exception*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "UDRDist\[0-9\]*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "UDRStatistics*.log"] [list $myname]
}
