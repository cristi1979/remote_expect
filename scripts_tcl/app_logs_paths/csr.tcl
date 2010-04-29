proc csr {{app_dir "/home/mind/mindcti/jboss"}} {
  set myname [lindex [info level 0] 0]

  set reg [logs_regular_expresions $myname] 
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "CSRCoreErrors"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "CSRWebErrors"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "CSRCore"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "CSRWeb"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "csrnicanicaSTAT.log"] [list $myname $reg]
}
