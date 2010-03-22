proc sipmanagement {{app_dir "/home/mind/mindcti/sipmanagement"}} {
  lappend ::apps_exceptions "$app_dir/path_to-log/files"
  lappend ::apps_logs "$app_dir/tomcat5/logs/manager*.log"
  lappend ::apps_logs "$app_dir/tomcat5/logs/localhost*.log"
  lappend ::apps_logs "$app_dir/tomcat5/logs/host-manager*.log"
  lappend ::apps_logs "$app_dir/tomcat5/logs/catalina*.log"
  lappend ::apps_logs "$app_dir/tomcat5/logs/catalina.out"
  lappend ::apps_logs "$app_dir/tomcat5/logs/admin*.log"
  lappend ::apps_statistics "$app_dir/path_to-log/files"
  lappend ::apps_dirs "$app_dir"
  set myname [lindex [info level 0] 0]
  lappend ::apps "$myname"
  proc $myname\_clean_exceptions {filename} {
    puts "coco"
  }
}
