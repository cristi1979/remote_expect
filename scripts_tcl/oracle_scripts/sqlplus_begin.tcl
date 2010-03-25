proc sqlplus_begin {} {
  sqlplus_launch_command "SET ECHO OFF"
  sqlplus_launch_command "SET FEEDBACK OFF"
  sqlplus_launch_command "SET HEADING OFF"
  sqlplus_launch_command "SET COLSEP ;"
  sqlplus_launch_command "SET pages 0 feed OFF"
  sqlplus_launch_command "SET line 20000"
  sqlplus_launch_command "SET TERMOUT OFF"
  sqlplus_launch_command "SET trimspool on"
}
