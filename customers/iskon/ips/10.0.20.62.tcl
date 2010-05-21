set user {mind}
set pass {minditit}
set prompt {mind:/u01/mind>}

add_app asc "/u01/mind/mindcti/asc" "/u01/mind/mindcti/mindcti_logs/asc"
add_app cdrcollector "/u01/mind/mindcti/cdr" "/u01/mind/mindcti/mindcti_logs/cdr"
add_app cdrprocessor "/u01/mind/mindcti/cdr" "/u01/mind/mindcti/mindcti_logs/cdr"
add_app recalc "/u01/mind/mindcti/recalc" "/u01/mind/mindcti/mindcti_logs/recalc"
add_app rtsserver "/u01/mind/mindcti/rts" "/u01/mind/mindcti/mindcti_logs/rts"

set ip "10.0.20.62" 
