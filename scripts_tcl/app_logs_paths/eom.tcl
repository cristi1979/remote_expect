proc eom {{app_dir "/home/mind/mindcti/jboss"}} {
  set myname [lindex [info level 0] 0]

  set reg [logs_regular_expresions $myname] 
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMShipmentValidationErrors"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMInvoiceValidationErrors"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMInvoiceGenerationRuleErrors"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMErrors"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMApiErrors"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMLayoutErrors"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMShipmentServer"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMLayoutServer"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMInvoiceServer"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMInvoiceServerTraceFile"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMInitializer"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMBatchServer"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMApi"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "eomnicanicaSTATS.log"] [list $myname $reg]
}
