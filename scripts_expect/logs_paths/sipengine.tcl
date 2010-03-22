proc sipengine {{app_dir "/home/mind/mindcti/sipengine"}} {
  lappend ::apps_exceptions "$app_dir/path_to-log/files"
  lappend ::apps_logs "$app_dir/syslog/trace.log.\[0-9\]*" "$app_dir/syslog/trace.log"
  lappend ::apps_logs "$app_dir/syslog/sas*.log"
  lappend ::apps_logs "$app_dir/syslog/radius.log.\[0-9\]*" "$app_dir/syslog/radius.log"
  lappend ::apps_logs "$app_dir/syslog/output"
  lappend ::apps_logs "$app_dir/syslog/media.log.\[0-9\]*" "$app_dir/syslog/media.log"
  lappend ::apps_logs "$app_dir/syslog/jgroups.log.\[0-9\]*" "$app_dir/syslog/jgroups.log"
  lappend ::apps_logs "$app_dir/syslog/syslog.log.\[0-9\]*" "$app_dir/syslog/syslog.log"
  lappend ::apps_logs "$app_dir/tciapps/tcidialer/log/output.log"
  lappend ::apps_logs "$app_dir/tciapps/tcifailover/log/output.log"
  lappend ::apps_logs "$app_dir/tciapps/tcionestage/log/output.log"
  lappend ::apps_logs "$app_dir/tciapps/tcizerostage/log/output.log"
  lappend ::apps_logs "$app_dir/tciapps/tciprepaid/log/output.log"
  lappend ::apps_statistics "$app_dir/syslog/stats.log.*"
  lappend ::apps_dirs "$app_dir"
  set myname [lindex [info level 0] 0]
  lappend ::apps "$myname"
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
