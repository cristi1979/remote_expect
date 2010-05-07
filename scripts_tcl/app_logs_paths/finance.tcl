proc finance {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
		  "FinanceExceptions"\
		  "FinanceErrors"\
		]
    }
    "logs" {
        return [list \
		  "FinanceInfo"\
		]
    }
    "statistics" {
        return [list \
			"FinanceThreadStatistics"\
			"FinanceProcessStatistics"\
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
