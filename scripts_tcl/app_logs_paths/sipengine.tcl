proc sipengine {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
		  "XXX_XXX"\
		]
    }
    "logs" {
        return [list \
		  "XXX_XXX"\
		]
    }
    "statistics" {
        return [list \
			"XXX_XXX"\
		]
    }
    "skip" {
        return [list \
			"XXX_XXX"\
		]
    }
	"extra" {
	  set myname [lindex [info level 0] 0]
	  set reg [logs_regular_expresions $myname]
	  
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "trace"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "sas"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "radius"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "output"] [list $myname  $::regexpempty]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "media"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "jgroups"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "syslog" "syslog"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tcidialer/log" "output.log"] [list $myname $::regexpempty]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tcifailover/log" "output.log"] [list $myname $::regexpempty]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tcionestage/log" "output.log"] [list $myname $::regexpempty]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tcizerostage/log" "output.log"] [list $myname $::regexpempty]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tciapps/tciprepaid/log" "output.log"] [list $myname $::regexpempty]
	  
	  myhash -add ::applications_array [list $::str_app_statistics $app_dir "syslog" "stats"] [list $myname $reg]
	}
    default {
      puts "\n\tERR: Wrong parameter: $logs_type."
	  exit 1;
    }
  } 
}
