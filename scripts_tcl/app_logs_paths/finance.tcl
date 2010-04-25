proc finance {{app_dir "/home/mind/mindcti/finance"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "FinanceExceptions\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "FinanceErrors\[0-9\]"] [list $myname]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "FinanceInfo\[0-9\]"] [list $myname]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "FinanceThreadStatistics\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "FinanceProcessStatistics\[0-9\]"] [list $myname]
}
