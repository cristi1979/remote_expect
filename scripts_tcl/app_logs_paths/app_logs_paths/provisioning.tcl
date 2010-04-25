proc provisioning {{app_dir "/home/mind/mindcti/apiserver"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "q1Exceptions.log.\[0-9\]*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "q1rInfo.log.\[0-9\]*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "q1tatistics.log.\[0-9\]*"] [list $myname]
}
