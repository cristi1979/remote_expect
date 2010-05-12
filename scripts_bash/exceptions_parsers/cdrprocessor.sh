function cdrprocessor() {

  function oldlogscdrprocessor() {

    reg='--------------------------------------------------------------------------------------------------'
    gawk --re-interval -v RS="$reg\n" -v FS="\n" '{ 
	c=split(FILENAME,arr,"/");fname=arr[c];
	if (NR>1) {
	split($0,array, "\n")
	max=0
	for (i=0;i<length(array);i++) {
	    if (array[i]!="") {
	    newarray[max]=array[i]
	    max++
	    }
	}
	pos=2
	if ( (newarray[pos] != "EXCEPTION LOG1") &&
	    (newarray[pos] != "java.io.IOException: Can'"'"'t obtain connection to host")) {
 	    print newarray[length(newarray)-1]
	    print newarray[0]
	    print newarray[1]
	    print newarray[2]
	    print newarray[3]
	    print "++++++++++++++++++++++++ old cdr processor or could be cdr collector "fname"\n";
	}
	} 
    }' $1

  }

  function newlogscdrprocessor() {
    reg='(ERROR|FATAL) Description :'
    gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{ 
	c=split(FILENAME,arr,"/");fname=arr[c];
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
		print "++++++++++++++++++++++++ "fname"\n";
	    }
	}
	MATCH=RT 
    }' $1
  }

  for filename in ${FILES[@]}; do
    if [ "$(head -1 $filename | cut -d " " -f3-4)" == "FATAL Description" -o "$(head -1 $filename | cut -d " " -f3-4)" == "ERROR Description" ];then
	newlogscdrprocessor $filename
    else
	oldlogscdrprocessor $filename
    fi
  done
} 
