proc tomcat {logs_type {app_dir ""} {app_logs ""}} {
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
			"nohup.out"\
		]
    }
	"extra" {
	  set myname [lindex [info level 0] 0]
	  set reg [logs_regular_expresions $myname]

	  myhash -add ::applications_array [list $::str_app_logs $app_dir "logs" "manager"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "logs" "localhost"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "logs" "host-manager"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "logs" "catalina"] [list $myname $reg]
	  myhash -add ::applications_array [list $::str_app_logs $app_dir "logs" "admin"] [list $myname $reg]
	}
    default {
      puts "\n\tERR: Wrong parameter: $logs_type."
	  exit 1;
    }
  } 
}
