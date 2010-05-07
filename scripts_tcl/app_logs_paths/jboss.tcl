proc jboss {logs_type {app_dir ""} {app_logs ""}} {
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
			"cdr_src"\
		]
    }
	"extra" {
		set myname [lindex [info level 0] 0]
		set reg [logs_regular_expresions $myname] 
		myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/.*/log/" "boot"] [list $myname $reg]
		myhash -add ::applications_array [list $::str_app_logs $app_dir "thirdparty/jboss/server/.*/log/" "server"] [list $myname $reg]

	    myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "thirdparty/jboss/server/.*/data"] [list $myname $reg]
	    myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "thirdparty/jboss/server/.*/tmp"] [list $myname $reg]
	    myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "thirdparty/jboss/server/.*/work"] [list $myname $reg]
	    myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "export"] [list $myname $reg]
	    myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "bin" "nohup.*"] [list $myname $reg]
		}
    default {
      puts "\n\tERR: Wrong parameter: $logs_type."
	  exit 1;
    }
  } 
}
