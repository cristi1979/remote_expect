proc workflow {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
			"JBPMErrors"\
		]
    }
    "logs" {
        return [list \
			"JBPMInfo"\
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
	}
    default {
      puts "\n\tERR: Wrong parameter: $logs_type."
	  exit 1;
    }
  } 
}
