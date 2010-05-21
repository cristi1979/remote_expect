set user {mind}
set pass {minditit}
set prompt {mind:/u01/mind>}

add_app jboss "/u01/mind/mindcti/MINDJBoss"
add_app csr "/u01/mind/mindcti/MINDJBoss" "/u01/mind/mindcti/mindcti_logs/MINDJBoss"
add_app rmweb "/u01/mind/mindcti/MINDJBoss" "/u01/mind/mindcti/mindcti_logs/MINDJBoss"

set ip "10.0.20.65" 
