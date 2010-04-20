proc recalc {{app_dir "/home/mind/mindcti/cdr"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "log-archives/*/RecalcExceptions.tar.gz"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "log-archives/*/Recalc.tar.gz"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "nicanica"] [list $myname]
}
