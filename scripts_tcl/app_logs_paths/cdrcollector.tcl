proc cdrcollector {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
			"CollectorExceptions"\
		]
    }
    "logs" {
        return [list \
			"CollectorInfo"\
			"Collector\[0-9\]"\
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
	}
    default {
      puts "\n\tERR: Wrong parameter: $logs_type."
	  exit 1;
    }
  } 
}
