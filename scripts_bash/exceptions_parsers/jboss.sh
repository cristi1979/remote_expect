function jboss() {
  reg="(ERROR|FATAL|INFO): [[:print:]]{1,}"
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

      if ( ($pos != "com.mind.utils.exceptions.MindTypeException: Cannot generate an invoice with usage. A periodic invoice should be generated.")&&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Invoice was not generated - tax amount for [[:print:]]{1,} is negative, -[[:print:]]{1,}[[:digit:]]{1,}(.|,)[[:digit:]]{1,}.$") &&
	    ($pos != "com.mind.csr.core.CSRException: Bank code not found." ) &&
	    ($pos != "com.mind.csr.core.CSRException: ID or Code must be entered." ) ){
	print MATCH,$1;
	print $2
	print $3
	print "++++++++++++++++++++++++ "fname"\n";
      }
    }
    MATCH=RT
  }' $filename
  done
}
