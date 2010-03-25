proc asc {{app_dir "/home/mind/mindcti/asc"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "ASCExceptions\[0-9\]*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "ASCInfo\[0-9\]*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RCInfo\[0-9\]*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "ASCStatistics\[0-9\]*.log"] [list $myname]

  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
