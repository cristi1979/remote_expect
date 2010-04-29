proc rtsserver {{app_dir "/home/mind/mindcti/rts"}} {
  set myname [lindex [info level 0] 0]

  set reg [logs_regular_expresions $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "RTSExceptions\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "Exception\[0-9\]"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RTSInfo\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RTSRejected\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "REJECTCALLS_\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RTSPstnRejected\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RCInfo\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RTS\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RC\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "FinanceInfo\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RemoteDisplay\[0-9\]"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "RTSStatistics\[0-9\]"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "cdr_bkp" ""] [list $myname $reg]
}
