proc tomcat {{app_dir "/home/mind/mindcti/apiserver"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "qExceptions.log.\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "qrInfo.log.\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "qtatistics.log.\[0-9\]"] [list $myname]
}
