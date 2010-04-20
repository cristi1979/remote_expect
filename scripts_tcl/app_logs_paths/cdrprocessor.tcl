proc cdrprocessor {{app_dir "/home/mind/mindcti/cdr"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "Exception"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "ProcessorExceptions"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "ProcessorInfo"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "Processor\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RCInfo"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "nicanica"] [list $myname]
}
