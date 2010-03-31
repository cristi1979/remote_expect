proc csr {{app_dir "/home/mind/mindcti/apiserver"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "csrExceptions.log.\[0-9\]*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "csrInfo.log.\[0-9\]*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "csrtatistics.log.\[0-9\]*"] [list $myname]
}
