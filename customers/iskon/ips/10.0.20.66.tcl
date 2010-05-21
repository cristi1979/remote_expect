set user {mind}
set pass {minditit}
set prompt {mind:/u01/mind>}

add_app jboss "/u01/mind/mindcti/MINDJBoss"
add_app provisioning "/u01/mind/mindcti/provisioning" "/u01/mind/mindcti/mindcti_logs/provisioning"
add_app udrserver "/u01/mind/mindcti/udrserver" "/u01/mind/mindcti/mindcti_logs/udr"

set ip "10.0.20.66" 
