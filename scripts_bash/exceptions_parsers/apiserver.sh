function apiserver() {
  reg='ERROR Description :'

  cat $(ls -tr ${FILES[@]}) | gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{
    if (NR>1) {
      if ( ($2 != "com.mind.core.Error: Account does not exist.") &&
	  ($2 !~ "^com.mind.core.Error: ANI \\[ [[:digit:]]{2,} \\] already exists!$") &&
	  ($2 !~ "^com.mind.core.Error: Finance transaction [[:digit:]]{2,} already canceled.$") &&
	  ($2 != "com.mind.core.Error: Service status is invalid.") &&
	  ($2 != "com.mind.core.Error: Cannot update a deactivated service.") &&
	  ($2 != "com.mind.core.Error: Account name cannot contain double quotes.") &&
	  ($2 != "com.mind.core.Error: Service not assigned to account") &&
	  ($2 != "com.mind.core.Error: This client does not have permission to logon.") &&
	  ($2 != "com.mind.core.Error: Service is already active.") &&
	  ($2 != "com.mind.core.Error: Account status is invalid.") &&
	  ($2 != "com.mind.core.Error: Account code already exists!") ) {
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

