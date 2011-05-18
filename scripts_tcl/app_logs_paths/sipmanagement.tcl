proc sipmanagement {logs_type {app_dir ""} {app_logs ""}} {
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

	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "manager"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "localhost"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "host-manager"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "catalina"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat5/logs" "admin"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat6/logs" "manager"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat6/logs" "localhost"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat6/logs" "host-manager"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat6/logs" "catalina"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "tomcat6/logs" "admin"] [list $myname $reg]
	}
    default {
      puts "\n\tERR: Wrong parameter: $logs_type."
	  exit 1;
    }
  } 
}
