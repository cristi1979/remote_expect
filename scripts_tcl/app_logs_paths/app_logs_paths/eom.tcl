proc eom {{app_dir "/home/mind/mindcti/cdr"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "eomException*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "eomProcessorInfo*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "eomnicanica"] [list $myname]
}
