function workflow() {
  for filename in ${FILES[@]}; do
  cat $filename | gawk --re-interval '{
	pos = 5;
	val = $(pos+1);
	for (i=pos+2;i<=NF;i++) {
	    val = val" "$i;
	}

	if (  !($pos == "[CmdUtils]" && ((val == "Cannot find any unfinished tasks for node Init Context Data") || (val =~ "^No process found with id [[:digit:]]{1,}$"))) ) {
	    print $0
	}
  }' 
  done
} 
