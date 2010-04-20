proc eom {{app_dir "/home/mind/mindcti/jboss"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMShipmentValidationErrors"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMInvoiceGenerationRuleErrors"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMErrors"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMApiErrors"] [list $myname]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "log" "EOMLayoutErrors"] [list $myname]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMShipmentServer"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMLayoutServer"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMInvoiceServer"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMInitializer"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMBatchServer"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "log" "EOMApi"] [list $myname]

  myhash -add ::applications_array [list $::str_app_statistics $app_dir "log" "eomnicanicaSTATS.log"] [list $myname]
}
