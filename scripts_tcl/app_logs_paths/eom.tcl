proc eom {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
		  "EOMApiErrors"\
		  "EOMErrors"\
		  "EOMExceptions"\
		  "EOMInvoiceGenerationRuleErrors"\
		  "EOMLayoutErrors"\
		  "EOMShipmentValidationErrors"\
		  "EOMShipmentValidationErrors"\
		  "FinanceErrors"\
		]
    }
    "logs" {
        return [list \
		  "CSRCore"\
		  "EOMApi"\
		  "EOMBatchServer"\
		  "EOMInitializer"\
		  "EOMInvoiceServer"\
		  "EOMInvoiceServerTraceFile"\
		  "EOMLayoutServer"\
		  "EOMShipmentServer"\
		  "EOMSqlTrace"\
		  "FinanceInfo"\
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
