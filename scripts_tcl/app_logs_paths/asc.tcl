proc asc {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
			"ASCExceptions\[0-9\]"\
		]
    }
    "logs" {
        return [list \
			"ASCInfo\[0-9\]"\
			"FinanceInfo\[0-9\]"\
			"RCInfo\[0-9\]"\
		]
    }
    "statistics" {
        return [list \
			"ASCStatistics\[0-9\]"\
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
