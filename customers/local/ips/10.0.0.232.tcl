set ip "10.0.0.232"
set user "test"
set pass "test1234"
#set ip "localhost"
set ::oracle_sid "BILL1022"
set prompt [string_asis "\[UAT2\]/u03/dumps> "]
#set prompt "\u001b\]0;cristi@gentoo:~\u0007\u001b\[?1034h\u001b\[01;32mcristi@gentoo\u001b\[01;34m ~ $\u001b\[00m "

array set ::applications_array {}
#oracle "/tmp/coco/"
add_app cdrcollector "/home/cristi/Downloads/test/u01/mind/cdr"
add_app udrserver "/home/cristi/Downloads/test/u01/mind/udrserver"
add_app apiserver "/home/cristi/Downloads/test/u01/mind/xmlapi"
add_app rtsserver "/home/cristi/Downloads/test/u01/mind/rts"

set extra_exp [string_asis "ORACLE_SID = \[NOT_SET\] ? "]
set extra_send "BILL1022"
set ::database_ip $ip
