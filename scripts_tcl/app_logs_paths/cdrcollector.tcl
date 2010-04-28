proc cdrcollector {{app_dir "/home/mind/mindcti/cdr"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "CollectorExceptions"] [list $myname]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "CollectorInfo"] [list $myname "testgrep"]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "Collector\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RCInfo"] [list $myname]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "nicanica"] [list $myname]

  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "cdr_src"] [list $myname]
}
