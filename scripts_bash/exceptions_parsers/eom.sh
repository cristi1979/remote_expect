function eom() {
  reg='INFO  Description :'

  cat $(ls -tr ${FILES[@]}) | sed '/^[ \t]*$/d' | gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{
    if (NR>1) { 
      if ( ($1 !~ "^Cannot generate invoice. Finance server did not complete transactions for account code [[:digit:]]{2,}$")  ) {
	print MATCH
	print $1;
	print "++++++++++++++++++++++++\n";
      }
    }
    MATCH=RT
  }'  
} 

