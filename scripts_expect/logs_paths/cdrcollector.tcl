proc cdrcollector {{app_dir "/home/mind/mindcti/cdr"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "Exception*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "CollectorExceptions*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "CollectorInfo*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "Collector\[0-9\]*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RCInfo*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "nicanica"] [list $myname]
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
