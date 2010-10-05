function asc() {
  reg='FATAL Description :'

  for filename in ${FILES[@]}; do
  gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{
	c=split(FILENAME,arr,"/");fname=arr[c];
    if (NR>1) {
      split(MATCH, array, " ")
      if ( array[3] == "ERROR" ) {
		pos = 1;
      } else if ( array[3] == "FATAL" ) {
		pos = 1
	  } else {
		pos =1
      } 
      if ( ($pos != "coco")) {
	print MATCH,$1;
	print "++++++++++++++++++++++++ "fname"\n";
      }
    }
    MATCH=RT
  }' $filename
  done
} 
