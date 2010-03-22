proc cdrcollectorsrc {{app_dir "/home/mind/mindcti/cdr"}} {
  lappend ::apps_exceptions "$app_dir/cdr_src/somedir/somefile"
  lappend ::apps_logs "$app_dir/cdr_src/*"
  lappend ::apps_statistics "$app_dir/cdr_src/somedir/somefile"
  lappend ::apps_dirs "$app_dir"
  set myname [lindex [info level 0] 0]
  lappend ::apps "$myname"
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
