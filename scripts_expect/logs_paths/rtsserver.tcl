proc rtsserver {{app_dir "/home/mind/mindcti/rts"}} {
  lappend ::apps_exceptions "$app_dir/log/RTSExceptions\[0-9\]*.log"
  lappend ::apps_exceptions "$app_dir/log/Exceptions\[0-9\]*.log"
  lappend ::apps_logs "$app_dir/log/RTSInfo\[0-9\]*.log"
  lappend ::apps_logs "$app_dir/log/RCInfo\[0-9\]*.log"
  lappend ::apps_logs "$app_dir/log/RTS\[0-9\]*.log"
  lappend ::apps_logs "$app_dir/log/RC\[0-9\]*.log"
  lappend ::apps_statistics "$app_dir/log/RTSStatistics\[0-9\]*.log"
  lappend ::apps_dirs "$app_dir"
  set myname [lindex [info level 0] 0]
  lappend ::apps "$myname"
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
