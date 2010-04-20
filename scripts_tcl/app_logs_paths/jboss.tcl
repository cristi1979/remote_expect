proc jboss {{app_dir "/home/mind/mindcti/jboss"}} {
  set myname [lindex [info level 0] 0]

  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "thirdparty/jboss/server/default/log/" "jbossnicanicaEXC.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/default/log/" "boot.log"] [list $myname]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/default/log/" "server"] [list $myname]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "thirdparty/jboss/server/default/log/" "jbossnicanicaSTAT.log"] [list $myname]
}
