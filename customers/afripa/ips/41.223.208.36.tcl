set user {mind}
set pass {Rt2100324.#@Cs}
set prompt {mind:/u01/mind>}

rtsserver "/u01/mind/mindcti/rts"
cdrcollector "/u01/mind/mindcti/cdr"
cdrprocessor "/u01/mind/mindcti/cdr_coco_too_many"
cdrcollectorsrc "/u01/mind/mindcti/cdr_coco_too_many"

set ip "41.223.208.36"
