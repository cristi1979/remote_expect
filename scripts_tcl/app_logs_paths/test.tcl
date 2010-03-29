proc test {{app_dir "/home/mind/mindcti/apiserver"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "/apps/rutilt" "*tray.png"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "man/man1" "rutilt*.\[0-9\]*.png"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "/icons/hicolor/48x48/apps" "*.png"] [list $myname]
}
