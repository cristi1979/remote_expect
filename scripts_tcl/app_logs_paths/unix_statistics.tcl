proc unix_statistics {} {
  set myname [lindex [info level 0] 0]

  set reg [logs_regular_expresions $myname]
  myhash -add ::applications_array [list $::str_unix_statistics $::bkp_rem_dir "" "mindstatistics_"] [list $myname $reg]
}
