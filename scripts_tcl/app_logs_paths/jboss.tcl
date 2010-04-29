proc jboss {{app_dir "/home/mind/mindcti/jboss"}} {
  set myname [lindex [info level 0] 0]

  set reg [logs_regular_expresions $myname] 
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "thirdparty/jboss/server/default/log/" "jbossnicanicaEXC.log"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_exceptions $app_dir "thirdparty/jboss/server/all/log/" "jbossnicanicaEXC.log"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/default/log/" "boot"] [list $myname $::regexpempty]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/default/log/" "server"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/all/log/" "boot"] [list $myname $::regexpempty]
  myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/all/log/" "server"] [list $myname $reg]
  
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "thirdparty/jboss/server/default/log/" "jbossnicanicaSTAT.log"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_statistics $app_dir "thirdparty/jboss/server/all/log/" "jbossnicanicaSTAT.log"] [list $myname $reg]

  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "thirdparty/jboss/server/default/data"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "thirdparty/jboss/server/default/tmp"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "thirdparty/jboss/server/default/work"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "export"] [list $myname $reg]
  myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "bin" "nohup.*"] [list $myname $reg]
}
