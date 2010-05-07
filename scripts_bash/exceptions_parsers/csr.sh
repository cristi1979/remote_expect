function csr() {
  reg="(ERROR|FATAL|INFO): [[:print:]]{1,}"
  for filename in ${FILES[@]}; do
  cat $filename | gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{ 
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
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Cannot generate an invoice with usage. A periodic invoice should be generated.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Print report failed.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: A mutually exclusive group \\([[:print:]]{1,}\\) cannot hold more than one selected feature.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Access key must be numeric.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Account Phone Number Range: [ [[:digit:]]{1,} - [[:digit:]]{1,}] already exists!$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Account class must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Account code [[:digit:]]{1,} class is not allowed to have descendent accounts$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Account goods instance does not exist.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Account not found.\rYou may want to try an extended search\rusing the search fields in the Accounts page.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Active tariff code cannot be changed.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Advanced field [[:print:]]{1,} does not exist.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: At least one search criteria must be entered.$")  &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Bank name must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Cannot reactivate a deactivated service under a deactivated subproduct.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Cannot use more than one goods item with IMSI mediation value for the same service.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Cannot use this goods item mediation fields.[[:cntrl:]]{1}Account has two services of the same type.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Card holder name must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Closed by is invalid.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Contact type, last name and first name already exist.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Credit card number length is invalid.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Credit card number length is limited to [[:digit:]]{1,} digits.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Discount must be less than or equal to 100.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: E-mail account name already exists!$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: E-mail account name is invalid.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: E-mail account name must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: E-mail address already exists!$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: E-mail address contains invalid characters.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: E-mail address local part is invalid.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: E-mail password must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Expiration date must be less than [[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Expiration year must be between [[:digit:]]{4} and [[:digit:]]{4}") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Feature cannot be selected [[:print:]]{1,}$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Force generation \\(ignore generation rules\\) is not relevant to draft invoice generation.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Framed IP address must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Framed IP netmask must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: From date must be greater or equal to [[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: From number is invalid.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Goods instance cannot be assigned directly to account or product/package.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Goods type has not been assigned to this service.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: IP already exists in pool.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: IP is in use$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Item key must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Last name must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Mailing contact is missing.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: One of the following must be entered: From date, To date.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: One of the following must be entered: Invoice No., From date, To date.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Package must be selected.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Password must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Phone Number [ [[:digit:]]{1,} ] already exists!$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Phone Number is invalid.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Phone Number must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Phone number mediation value already assigned.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Processor is not running! [[:cntrl:]]{2} Please run processor.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Shipment section not allowed. Account is not billable or is of type voucher/debit card.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Subnet mask must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Tariff plan end date is invalid.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: The service cannot have IP allocation and multiple concurrent sessions defined.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: User Code must be numeric.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: User ID already exists!$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: User ID is invalid.$")  &&
	    ($pos !~ "^com.mind.csr.core.CSRException: User ID must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Value [[:digit:]]{1,} must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Value [[:digit:]]{1,} must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Value must be entered.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Web login name already exists!$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Zip must be at most [[:digit:]]{1,} characters.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: A scheduled package request already exists for this account.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Amount is invalid.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Amount must be entered.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Cannot generate invoice. The account has missed a periodic invoice.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Discount is invalid.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Invalid scheduled date.[[:cntrl:]]{2}The scheduled date must be greater than current date.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Invoice for new account should include goods, adjustments and/or interest calculation only.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Invoice was not generated - amount due [[:print:]]{1,}[[:digit:]]{1,}.[[:digit:]]{1,} is less than [[:print:]]{1,}[[:digit:]]{1,}.[[:digit:]]{1,}.$") &&
	    ($pos !~ "^com.mind.csr.core.CSRException: Cannot add finance transaction for non-billable account.$") &&
	    ($pos !~ "^com.mind.utils.exceptions.MindTypeException: Quantity is invalid.$")		) {
	print MATCH, $1;
	print $2
	if (pos==2) {
	    print $3
	    print $4
	}
	print "++++++++++++++++++++++++\n";
      }
    }
    MATCH=RT 
  }'
#   cat $filename | gawk --re-interval '{
# 	pos = 5;
# 	val = $(pos+1);
# 	for (i=pos+2;i<=NF;i++) {
# 	    val = val" "$i;
# 	}
# 
# 	if (  !($pos == "[DoCCProcessorPayment]" && ((val == "Read timed out") || (val == "Connection reset") || (val == "Connection refused"))) ) {
# 	    print $0
# 	}
#   }'
  done
} 
