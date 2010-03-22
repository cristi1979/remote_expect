proc oracle {{app_dir "/somethig/that/is/wrong"}} {
  lappend ::apps_exceptions "$app_dir/path_to-log/files"
  lappend ::apps_logs "$app_dir/path_to-log/files"
  lappend ::apps_statistics "$app_dir/path_to-log/files"
  lappend ::apps_dirs "$app_dir"
  set myname [lindex [info level 0] 0]
  lappend ::apps "$myname"
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
