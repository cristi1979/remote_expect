proc eom {{app_dir "/home/mind/mindcti/jboss"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMShipmentValidationErrors\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMInvoiceValidationErrors\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMInvoiceGenerationRuleErrors\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMErrors\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMApiErrors\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMLayoutErrors\[0-9\]"] [list $myname]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMShipmentServer\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMLayoutServer\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMInvoiceServer\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMInvoiceServerTraceFile\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMInitializer\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMBatchServer\[0-9\]"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMApi\[0-9\]"] [list $myname]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "eomnicanicaSTATS.log"] [list $myname]
}
