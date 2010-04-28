proc unix_statistics {{app_dir "/tmp/mindcti"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_unix_statistics $::bkp_rem_dir "" "mindstatistics_.*"] [list $myname]
}
