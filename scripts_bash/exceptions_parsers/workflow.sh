function workflow() {
reg="(ERROR|FATAL|INFO): [[:print:]]{1,}"
  for filename in ${FILES[@]}; do
  gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{ 
	c=split(FILENAME,arr,"/");fname=arr[c];
	if (NR>1) { 
	split(MATCH, array, " ")
	    if ( array[3] == "ERROR" ) {
		pos = 1;
	    } else {
		pos =1
	    }
	}
	if ( $pos!="" &&
	    !($pos ~ "\\[CmdUtils\\]" && ( ($pos ~ "Cannot find any unfinished tasks for node Init Context Data") || ($pos ~ "No process found with id [[:digit:]]{1,}") || ($pos ~ "Cannot find any unfinished tasks for node [[:print:]]{1,}") ) ) &&
	    !($pos ~ "\\[CoreEjbClient\\]" && ( ($pos ~ "Opera\\?iunea nu este permis\\?.") || ($pos ~ "Utilizatorul nu poate \\?terge cont") || ($pos ~ "Cont nu exist?.")) )) {
	    print MATCH, $1; 
	    print "++++++++++++++++++++++++ "fname"\n";
	}
	MATCH=RT 
  }'  $filename
  done
} 
