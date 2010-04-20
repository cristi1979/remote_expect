proc rtsserver {{app_dir "/home/mind/mindcti/rts"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "RTSExceptions\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "Exceptions\[0-9\]"] [list $myname]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RTSInfo\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RTSRejected\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RTSPstnRejected\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RCInfo\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RTS\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RC\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "FinanceInfo\[0-9\]"] [list $myname]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "RTSStatistics\[0-9\]"] [list $myname]
}
