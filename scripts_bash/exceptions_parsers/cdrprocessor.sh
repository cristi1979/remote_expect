function cdrprocessor() {

  function oldlogscdrprocessor() {
    cat $1 | gawk --re-interval -v FS=";" '{
	if ($NF!=" <!-- USER NOT FOUND.") {
	    print $0
	}
    }'
  }

  function newlogscdrprocessor() {
    reg='(ERROR|FATAL) Description :'
    cat $1 | gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{ 
	if (NR>1) {
	  split(MATCH, array, " ")
      if ( array[3] == "ERROR" ) {
		pos = 2;
      } else if ( array[3] == "FATAL" ) {
		pos = 2
	  } else {
		pos =1
      } 
	    if ( ($pos !~ "^coco$")) {
		print MATCH, $1;
		print $2;
		print $3;
		print "++++++++++++++++++++++++\n";
	    }
	}
	MATCH=RT 
    }'
  }

  for filename in ${FILES[@]}; do
    if [ "$(head -1 $filename | cut -d " " -f3-4)" == "FATAL Description" -o "$(head -1 $filename | cut -d " " -f3-4)" == "ERROR Description" ];then
	newlogscdrprocessor $filename
    else
	oldlogscdrprocessor $filename
    fi
  done
} 
