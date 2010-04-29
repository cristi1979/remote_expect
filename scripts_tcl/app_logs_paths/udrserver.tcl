proc udrserver {{app_dir "/home/mind/mindcti/udr"}} {
  set myname [lindex [info level 0] 0]

  set reg [logs_regular_expresions $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "UDRDist-Exception\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "UDRDist\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "UDRStatistics"] [list $myname $reg]
}
