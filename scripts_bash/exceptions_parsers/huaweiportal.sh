function huaweiportal() {
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

      if ( ($pos != "") &&
	    ($pos != "com.mind.csr.core.CSRException: Contas năo existe.") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Voucher [[:print:]]{1,} est� inutiliz�vel.$") &&
	    ($pos != "com.mind.csr.core.CSRException: Advanced filter must be entered.") ) {
	print MATCH, $1;
	print $2
	print $3
	print $4
	print "++++++++++++++++++++++++ "fname"\n";
      }
    }
    MATCH=RT 
  }' $filename
  done
} 

