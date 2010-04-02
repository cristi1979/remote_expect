set user "mind"
set pass "Voice56Vm"
set prompt "mind:/u01/mind>"

#rtsserver "/u01/mind/rts"
## too many logs, so reset the list
cdrcollector "/u01/mind/cdr"
cdrprocessor "/u01/mind/cdr"
cdrcollectorsrc "/u01/mind/cdr"

set ip "200.52.193.215"
