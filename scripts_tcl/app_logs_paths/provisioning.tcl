proc provisioning {logs_type {app_dir ""} {app_logs ""}} {
  switch $logs_type {
    "exceptions" {
        return [list \
		  "ProvisioningAPI-Exceptions"\
		  "PPA-Exceptions"\
		  "PM-Exceptions"\
		  "Cirpack-Rejected-Invalid-.*"\
		  "Cirpack-Exceptions"\
		]
    }
    "logs" {
        return [list \
		  "ProvisioningAPI-Sql"\
		  "ProvisioningAPI"\
		  "PPA-Sql"\
		  "PPA"\
		  "PM-Sql"\
		  "PM"\
		  "Cirpack"\
		  "Cirpack-Reject"\
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
