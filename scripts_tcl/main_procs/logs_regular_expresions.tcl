proc logs_regular_expresions {app} {
  puts "\n\tMSG: App $app using regular expresion for mind version $::mind_version."
  switch $app {
	"rtsserver" -
	"recalc" -
	"cdrprocessor" -
	"cdrcollector" -
	"asc" -
	"finance" -
	"udrserver" {
	    if {$::mind_version=="" || $::mind_version=="5"} { 
	      return {[0-9]\{5,8\}\(_[0-9]\{0,5\}\)\?.log$}
	    } elseif {$::mind_version=="6"} {
	      return {[0-9]\{5,8\}\(_[0-9]\{0,5\}\)\?.log\(.gz\)\?$}
	    } else {
	      return $::regexpmind
	    }
	}
	"sipengine" -
	"jboss" -
	"apiserver" {
	    if {$::mind_version=="" || $::mind_version=="5"} { 
	      return {.log\(\.[0-9]\{1,5\}\)\?$}
	    } else {
	      return $::regexpmind
	    }
	}
	"tomcat" -
	"sipmanagement" {
	    return {\(.out\|.[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}.log\)$}
	}
	"huaweiportal" -
	"csr" -
	"events" -
	"workflow" -
	"eom" {
	    return $::regexpmind
	}
	"unix_statistics" {
	    return {.*.log$}
	}
	default { return $::regexpmind }
  }
}
