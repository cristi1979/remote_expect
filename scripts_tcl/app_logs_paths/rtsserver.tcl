proc rtsserver {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
		  "RTSExceptions\[0-9\]"\
		  "Exception\[0-9\]"\
		]
    }
    "logs" {
        return [list \
		"RTSInfo\[0-9\]"\
		"RTSRejected\[0-9\]"\
		"REJECTCALLS_\[0-9\]"\
		"RTSPstnRejected\[0-9\]"\
		"RCInfo\[0-9\]"\
		"RTS\[0-9\]"\
		"RC\[0-9\]"\
		"FinanceInfo\[0-9\]"\
		"RemoteDisplay\[0-9\]"\
		]
    }
    "statistics" {
        return [list \
			"RTSStatistics\[0-9\]"\
		]
    }
    "skip" {
        return [list \
			"cdr_bkp"\
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
