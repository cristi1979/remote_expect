function finance() {
    reg='(ERROR|FATAL) Description :'

  for filename in ${FILES[@]}; do
  gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{
	c=split(FILENAME,arr,"/");fname=arr[c];
	if (NR>1) {
      split(MATCH, array, " ")
      if ( array[3] == "ERROR" ) {
		pos = 1;
      } else if ( array[3] == "FATAL" ) {
		pos = 2
	  } else {
		pos =1
      } 
	if ( ($pos !~ "^Account with code: [[:print:]]{2,} is performing a call$") &&
	    ($pos !~ "^[[:print:]]{2,},Origin:Batch,MessageType:none fatal failure because account has unterminated call$") &&
	    ($pos !~ "^Save data, for accountid: [[:digit:]]{1,}, failed$")) {
	    print MATCH, $1;
	    print $2;
	    print $3;
	    print "++++++++++++++++++++++++ "fname"\n";
	}
	}
	MATCH=RT
    }' $filename
  done
} 
