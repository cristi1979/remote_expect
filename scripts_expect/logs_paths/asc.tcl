proc asc {{app_dir "/home/mind/mindcti/asc"}} {
  lappend ::apps_exceptions "$app_dir/log/ASCExceptions\[0-9\]*.log"
  lappend ::apps_logs "$app_dir/log/ASCInfo\[0-9\]*.log"
  lappend ::apps_logs "$app_dir/log/RCInfo\[0-9\]*.log"
  lappend ::apps_statistics "$app_dir/log/ASCStatistics\[0-9\]*.log"
  lappend ::apps_dirs "$app_dir"
  set myname [lindex [info level 0] 0]
  lappend ::apps "$myname"
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}