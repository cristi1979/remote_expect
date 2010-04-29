proc finance {{app_dir "/home/mind/mindcti/finance"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "FinanceExceptions"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "FinanceErrors"] [list $myname]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "FinanceInfo"] [list $myname]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "FinanceThreadStatistics"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "FinanceProcessStatistics"] [list $myname]
}
