proc oracle {{app_dir "/somethig/that/is/wrong"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "relative_path_to_log_dir" "files"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "relative_path_to_log_dir" "files"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "relative_path_to_log_dir" "files"] [list $myname]
}
