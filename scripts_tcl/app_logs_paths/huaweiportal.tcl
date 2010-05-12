proc huaweiportal {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
		  "HuaweiErrors"\
		]
    }
    "logs" {
        return [list \
		  "HuaweiInfo"\
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
