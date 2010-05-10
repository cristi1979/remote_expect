function rtsserver() {
  function oldlogsrtsserver() {
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
	if ( (newarray[pos] != "EXCEPTION LOG1") ) {
 	    print newarray[length(newarray)-1]
	    print newarray[0]
	    print newarray[1]
	    print newarray[2]
	    print newarray[3]
	    print "++++++++++++++++++++++++ "fname"\n";
	}
	} 
    }' $1
  }

  function newlogsrtsserver() {
    ## ex: Tariff not found in global list. Tariff code = [[:print:]]{1,}, Tariff date = [[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}.[[:digit:]]{1,}, accountID: [[:digit:]]{1,}, service ID: [[:digit:]]{1,}
    reg='(ERROR|FATAL) Description :'
    gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{ 
	if (NR>1) {
      split(MATCH, array, " ")
      if ( array[3] == "ERROR" ) {
		pos = 2;
      } else {
		pos =1
      } 

	    if ( ($1 !~ "^coco$")) {
		print MATCH, $1;
		print $2;
		print $3;
		print $4;
		print "++++++++++++++++++++++++ "fname"\n";
	    }
	}
	MATCH=RT 
    }' $1
  }

  for filename in ${FILES[@]}; do
    if [ "$(head -1 $filename)" == "EXCEPTION LOG" ];then
	oldlogsrtsserver $filename
    else
	newlogsrtsserver $filename
    fi
  done
} 
