proc dbimport {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
			"DbimportErrors\[0-9\]"\
			"DbimportExceptions\[0-9\]"\
			"ImportPaymentsException\[0-9\]"\
		]
    }
    "logs" {
        return [list \
			"APIInfo\[0-9\]"\
			"ImportPaymentsInfo\[0-9\]"\
			"DBImport\[0-9\]"\
			"DBImportData\[0-9\]"\
			"DBImportInfo\[0-9\]"\
			"Dbimportinfo\[0-9\]"\
		]
    }
    "statistics" {
        return [list \
			"DBImportStatistics\[0-9\]"\
			"FinalStatistics\[0-9\]"\
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
