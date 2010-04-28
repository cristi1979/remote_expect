proc jboss {{app_dir "/home/mind/mindcti/jboss"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "thirdparty/jboss/server/default/log/" "jbossnicanicaEXC.log"] [list $myname]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/default/log/" "boot"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/default/log/" "server"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "thirdparty/jboss/server/default/log/" "jbossnicanicaSTAT.log"] [list $myname]

  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "thirdparty/jboss/server/default/log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "thirdparty/jboss/server/default/tmp"] [list $myname]
  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "thirdparty/jboss/server/default/work"] [list $myname]
  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "export"] [list $myname]
  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "bin" "nohup.*"] [list $myname]
}
