set user "test"
set pass "test1234"
set prompt [string_asis "\[UAT2\]/u03/dumps> "]

array set ::applications_array {}
oracle "/tmp/coco/"

set extra_exp [string_asis "ORACLE_SID = \[NOT_SET\] ? "]
set extra_send "BILL1022"
set ip "10.0.0.232"
set ::database_ip $ip
