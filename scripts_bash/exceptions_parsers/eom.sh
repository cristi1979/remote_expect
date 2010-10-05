function eom() {
  reg='(ERROR|FATAL|INFO)  Description :'
#cat $(ls -tr ${FILES[@]})
  for filename in ${FILES[@]}; do
  gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{
	c=split(FILENAME,arr,"/");fname=arr[c];
    if (NR>1) { 
      split(MATCH, array, " ")
      if ( array[3] == "INFO" ) {
		pos = 1;
      } else {
		pos =2
      }

      if ( ($pos !~ "^com.mind.eom.invoice.exceptions.InvoiceValidationException: Invoice was not generated - amount due [[:print:]]{1,}[[:digit:]]{1,}.[[:digit:]]{1,} is less than [[:print:]]{1,}[[:digit:]]{1,}.[[:digit:]]{1,}.$") &&
	    ($pos !~ "^Cannot generate invoice. Invoice  for account code [[:print:]]{1,} failed due to generation rule$") &&
	    ($pos !~ "^Cannot generate invoice. Cannot generate invoice. The account has missed a periodic invoice. Account id [[:digit:]]{1,}$") &&
	    ($pos !~ "^Cannot generate invoice. Cannot generate an invoice with usage. A periodic invoice should be generated. for billing periods $") &&
	    ($pos !~ "^Cannot generate invoice. The account has missed a periodic invoice. Account id [[:digit:]]{1,}$") &&
	    ($pos !~ "^Cannot generate invoice. Invoice for new account should include goods, adjustments and/or interest calculation only. for account code [[:print:]]{1,}$") &&
	    ($pos !~ "^Cannot generate invoice. Invoice / final invoice was not generated -  tax amount for [[:print:]]{1,} is negative \\( -[[:print:]]{1,}[[:digit:]]{1,}.[[:digit:]]{1,} \\).$") &&
	    ($pos !~ "^Cannot generate invoice. Final invoice  for account code [[:print:]]{1,} failed due to final generation rule$") &&
	    ($pos !~ "^Cannot generate invoice. Finance server did not complete transactions for account code [[:print:]]{1,}$") ) {
	print MATCH,$1;
	print $2
	if (pos==2) {
	    print $3
	    print $4
	}
	print "++++++++++++++++++++++++ "fname"\n";
      }
    }
    MATCH=RT
  }' $filename
  done 
} 
