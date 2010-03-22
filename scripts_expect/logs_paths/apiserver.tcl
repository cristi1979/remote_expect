proc apiserver {{app_dir "/home/mind/mindcti/apiserver"}} {
  lappend ::apps_exceptions "$app_dir/log/APIExceptions.log.\[0-9\]*"
  lappend ::apps_logs "$app_dir/log/XMLAPIInfo.log.\[0-9\]*"
  lappend ::apps_statistics "$app_dir/log/APIStatistics.log.\[0-9\]*"
  lappend ::apps_dirs "$app_dir"
  set myname [lindex [info level 0] 0]
  lappend ::apps "$myname"
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
