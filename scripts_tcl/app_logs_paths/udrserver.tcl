proc udrserver {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
		  "UDRDist-Exception\[0-9\]"\
		]
    }
    "logs" {
        return [list \
		  "UDRDist\[0-9\]"\
		]
    }
    "statistics" {
        return [list \
			"UDRStatistics"\
		]
    }
    "skip" {
        return [list \
			"XXX_XXX"\
		]
    }
	"extra" {
	}
    default {
      puts "\n\tERR: Wrong parameter: $logs_type."
	  exit 1;
    }
  } 
}
