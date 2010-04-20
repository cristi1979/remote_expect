proc sipengine {{app_dir "/home/mind/mindcti/sipengine"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "nicanica"] [list $myname]
  
  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "trace"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "sas*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "radius"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "output"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "media"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "jgroups"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "syslog"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tcidialer/log" "output.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tcifailover/log" "output.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tcionestage/log" "output.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tcizerostage/log" "output.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tciprepaid/log" "output.log"] [list $myname]
  
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "syslog" "stats"] [list $myname]
}
