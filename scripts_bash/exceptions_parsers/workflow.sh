function workflow() {
  for filename in ${FILES[@]}; do
  gawk --re-interval '{
	c=split(FILENAME,arr,"/");fname=arr[c];

	if ( $0!="" &&
	    !($0 ~ "\\[CmdUtils\\]" && ( ($0 ~ "Cannot find any unfinished tasks for node Init Context Data") || ($0 ~ "No process found with id [[:digit:]]{1,}") || ($0 ~ "Cannot find any unfinished tasks for node [[:print:]]{1,}") ) ) &&
	    !($0 ~ "\\[CoreEjbClient\\]" && ( ($0 ~ "Opera\\?iunea nu este permis\\?.") || ($0 ~ "Utilizatorul nu poate \\?terge cont") || ($0 ~ "Cont nu exist?.")) )) {
	    print $0;
	    print "++++++++++++++++++++++++ "fname"\n";
	}
  }'  $filename
  done
} 
