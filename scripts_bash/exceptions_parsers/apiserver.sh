function apiserver() {
  reg='ERROR Description :'

  cat $(ls -tr ${FILES[@]}) | gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{
    if (NR>1) {
      if ( ($2 != "com.mind.core.Error: Account does not exist.") &&
	  ($2 !~ "^com.mind.core.Error: ANI \\[ [[:digit:]]{2,} \\] already exists!$") &&
	  ($2 !~ "^com.mind.core.Error: Finance transaction [[:digit:]]{2,} already canceled.$") &&
	  ($2 !~ "^com.mind.core.Error: Session \\[ [[:digit:]]{1,} \\] not found or expired$") &&
	  ($2 != "com.mind.core.Error: Service status is invalid.") &&
	  ($2 != "com.mind.core.Error: Cannot update a deactivated service.") &&
	  ($2 != "com.mind.core.Error: Account name cannot contain double quotes.") &&
	  ($2 != "com.mind.core.Error: Service not assigned to account") &&
	  ($2 != "com.mind.core.Error: This client does not have permission to logon.") &&
	  ($2 != "com.mind.core.Error: Service is already active.") &&
	  ($2 != "com.mind.core.Error: Account status is invalid.") &&
	  ($2 != "com.mind.core.Error: Account code already exists!")  &&
	  ($2 != "com.mind.core.Error: Operation is not allowed - user provider different from account provider") &&
	  ($2 != "com.mind.core.Error: Enter a positive value for Credit limit.") &&
	  ($2 != "com.mind.core.Error: id is invalid.") &&
	  ($2 != "com.mind.core.Error: System logon failed. Wrong password.") &&
	  ($2 != "com.mind.core.Error: Api session not initialized") &&
	  ($2 != "com.mind.core.Error: ANI group does not exist") &&
	  ($2 != "com.mind.core.Error: For prepaid accounts, there can never be more than one active session at a time") &&
	  ($2 != "com.mind.core.Error: The element type "balance_calculation_method" must be terminated by the matching end-tag \"</balance_calculation_method>\".") &&
	  ($2 != "com.mind.core.Error: Account not found")  &&
	  ($2 != "com.mind.core.Error: Enter a positive value for Amount.")) {
	print MATCH
	print $1;
	print $2;
	print $3;
	print "++++++++++++++++++++++++\n";
      }
    }
    MATCH=RT
  }'  
} 

