proc sipmanagement {{app_dir "/home/mind/mindcti/sipmanagement"}} {
  set myname [lindex [info level 0] 0]

  set reg [logs_regular_expresions $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "nicanica"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "manager"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "localhost"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "host-manager"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "catalina"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "admin"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "nicanica"] [list $myname $reg]
}
