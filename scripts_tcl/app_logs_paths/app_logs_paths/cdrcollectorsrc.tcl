proc cdrcollectorsrc {{app_dir "/home/mind/mindcti/cdr"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "cdr_src/*/" "REJECTCALLS_\[0-9\]*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "cdr_src" "PROCESS_INFO_\[0-9\]*.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "cdr_src" "*.BKP*"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "cdr_src" "nicanica"] [list $myname]
}
