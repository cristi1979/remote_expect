function apiserver() {
  reg='ERROR Description :'

  for filename in ${FILES[@]}; do
  gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{
	c=split(FILENAME,arr,"/");fname=arr[c];
    if (NR>1) {
      split(MATCH, array, " ")
      if ( array[3] == "ERROR" ) {
		pos = 2;
      } else if ( array[3] == "FATAL" ) {
		pos = 1
	  } else {
		pos =1
      }
      if ( ($pos != "com.mind.core.Error: Account does not exist.") &&
	  ($pos !~ "^com.mind.core.Error: ANI \\[ [[:digit:]]{2,} \\] already exists!$") &&
	  ($pos !~ "^com.mind.core.Error: Finance transaction [[:digit:]]{2,} already canceled.$") &&
	  ($pos !~ "^com.mind.core.Error: Session \\[ [[:digit:]]{1,} \\] not found or expired$") &&
	  ($pos !~ "^com.mind.core.Error: Session [[:digit:]]{1,} not found or expired$") &&

	  ($pos != "com.mind.core.Error: Service status is invalid.") &&
	  ($pos != "com.mind.core.Error: Cannot update a deactivated service.") &&
	  ($pos != "com.mind.core.Error: Account name cannot contain double quotes.") &&
	  ($pos != "com.mind.core.Error: Service not assigned to account") &&
	  ($pos != "com.mind.core.Error: This client does not have permission to logon.") &&
	  ($pos != "com.mind.core.Error: Service is already active.") &&
	  ($pos != "com.mind.core.Error: Account status is invalid.") &&
	  ($pos != "com.mind.core.Error: Account code already exists!")  &&
	  ($pos != "com.mind.core.Error: Account ANI already exists!")  &&
	  ($pos != "com.mind.core.Error: Operation is not allowed - user provider different from account provider") &&
	  ($pos != "com.mind.core.Error: Enter a positive value for Credit limit.") &&
	  ($pos != "com.mind.core.Error: id is invalid.") &&
	  ($pos != "com.mind.core.Error: System logon failed. Wrong password.") &&
	  ($pos != "com.mind.core.Error: Api session not initialized") &&
	  ($pos != "com.mind.core.Error: ANI group does not exist") &&
	  ($pos != "com.mind.core.Error: For prepaid accounts, there can never be more than one active session at a time") &&
	  ($pos != "com.mind.core.Error: The element type "balance_calculation_method" must be terminated by the matching end-tag \"</balance_calculation_method>\".") &&
	  ($pos != "com.mind.core.Error: Account not found")  &&
	  ($pos != "com.mind.core.Error: Session [[:digit:]]{1,} not found or expired")  &&
	  ($pos != "com.mind.core.Error: Enter a positive value for Amount.")) {
	print MATCH,$1;
	print $2;
	print $3;
	print "++++++++++++++++++++++++ "fname"\n";
      }
    }
    MATCH=RT
  }' $filename
  done
}
