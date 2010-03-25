set user "test"
set pass "test1234"
set prompt [string_asis "\[UAT2\]/u03/dumps> "]

set ::from_apps [list rtsserver udrserver cdrcollector]
oracle "/tmp/coco/"
asc "/dodo///"
udrserver "u01/mind/udrserver////"
rtsserver "/u01/mind//rts/"
cdrcollector "/u01/collector"

set extra_exp [string_asis "ORACLE_SID = \[NOT_SET\] ? "]
set extra_send "BILL1022"
set ip "10.0.0.232"
set ::database_ip $ip
