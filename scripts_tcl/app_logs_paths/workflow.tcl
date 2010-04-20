proc workflow {{app_dir "/home/mind/mindcti/jboss"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "JBPMErrors\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "JBPMInfo\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "jbpmnicanicaSTATS.log"] [list $myname]
}
