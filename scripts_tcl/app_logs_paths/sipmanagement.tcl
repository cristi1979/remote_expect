proc sipmanagement {{app_dir "/home/mind/mindcti/sipmanagement"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "nicanica"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "manager*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "localhost*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "host-manager*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "catalina*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "catalina.out"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "admin*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "nicanica"] [list $myname]
}
