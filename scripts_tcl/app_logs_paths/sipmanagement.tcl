proc sipmanagement {{app_dir "/home/mind/mindcti/sipmanagement"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "nicanica"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "manager*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "localhost*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "host-manager*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "catalina*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "admin*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "nicanica"] [list $myname]
}
