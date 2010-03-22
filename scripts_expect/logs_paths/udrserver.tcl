proc udrserver {{app_dir "/home/mind/mindcti/udr"}} {
  lappend ::apps_exceptions "$app_dir/log/UDRDist-Exception*.log"
  lappend ::apps_logs "$app_dir/log/UDRDist\[0-9\]*.log"
  lappend ::apps_statistics "$app_dir/log/UDRStatistics*.log"
  lappend ::apps_dirs "$app_dir"
  set myname [lindex [info level 0] 0]
  lappend ::apps "$myname"
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
