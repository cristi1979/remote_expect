proc apiserver {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
			"APIErrors"\
			"APIExceptions"\
		]
    }
    "logs" {
        return [list \
			"APIInfo"\
			"XMLAPIInfo"\
		]
    }
    "statistics" {
        return [list \
			"APIStatistics"\
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
