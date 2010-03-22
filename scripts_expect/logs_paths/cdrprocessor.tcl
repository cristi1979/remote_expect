proc cdrprocessor {{app_dir "/home/mind/mindcti/cdr"}} {
  lappend ::apps_exceptions "$app_dir/log/Exception*.log"
  lappend ::apps_exceptions "$app_dir/log/ProcessorExceptions*.log"
  lappend ::apps_logs "$app_dir/log/ProcessorInfo*.log"
  lappend ::apps_logs "$app_dir/log/Processor\[0-9\]*.log"
  lappend ::apps_logs "$app_dir/log/RCInfo*.log"
  lappend ::apps_statistics "$app_dir/log/somefiles"
  lappend ::apps_dirs "$app_dir"
  set myname [lindex [info level 0] 0]
  lappend ::apps "$myname"
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
