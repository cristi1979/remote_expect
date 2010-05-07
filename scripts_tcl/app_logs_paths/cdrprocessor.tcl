proc cdrprocessor {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
		  "Exception"\
		  "ProcessorExceptions"\
		]
    }
    "logs" {
        return [list \
		  "ProcessorInfo"\
		  "Processor\[0-9\]"\
		  "RCInfo"\
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
		myhash -add ::applications_array [list $::str_app_logs $app_dir "cdr_src/.*/" "PROCESS_INFO_\[0-9\]"] [list $myname $reg]
	}
    default {
      puts "\n\tERR: Wrong parameter: $logs_type."
	  exit 1;
    }
  } 
}
