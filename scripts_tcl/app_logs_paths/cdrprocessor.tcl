proc cdrprocessor {{app_dir "/home/mind/mindcti/cdr"}} {
  set myname [lindex [info level 0] 0]

  set reg [logs_regular_expresions $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "Exception"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "ProcessorExceptions"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "cdr_src/.*/" "REJECTCALLS_\[0-9\]"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "cdr_src/.*/" "PROCESS_INFO_\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "ProcessorInfo"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "Processor\[0-9\]"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "RCInfo"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "nicanica"] [list $myname $reg]
}
