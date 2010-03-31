#!/bin/sh

##input: work_dir customer ip app emails files
if [ $# -lt 6 ];then
  echo "We need work_dir customer ip app emails files"
  exit 1
fi

#ALL_APPLICATIONS=( apiserver asc cdrcollectorsrc cdrcollector cdrprocessor oracle rtsserver sipengine sipmanagement udrserver)
ALL_APPLICATIONS=( $(ls $(dirname $0)/../scripts_tcl/app_logs_paths/ | sed s/\.tcl\// | awk '{printf "%s ",$0} END {print ""}') )
declare -a FILES
OUR_APP=""
EMAILS=""
CUSTOMER=""
REMOTE_IP=""
WORK_DIR="/tmp"
POS=0
err=1

for var in ${@}; do
  let POS=$POS+1
  if [ $POS = 1 ]; then
    WORKDIR=$var;
    echo "Working directory is $WORKDIR"
  elif [ $POS = 2 ]; then
    CUSTOMER=$var;
    echo "Customer is $CUSTOMER"
  elif [ $POS = 3 ]; then
    REMOTE_IP=$var;
    echo "Remote ip is $REMOTE_IP"
  elif [ $POS = 4 ]; then
    OUR_APP=$var;
    echo "App is $OUR_APP"
  elif [ $POS = 5 ]; then
    EMAILS=$var;
    echo "Emails are $EMAILS"
  else
    FILES=( "${FILES[@]}" "$var" )
  fi
done

echo "Files are ${FILES[@]}"

for app in ${ALL_APPLICATIONS[@]}; do
  if [ $app == $OUR_APP ];then
    echo ok
    err=0
    break
  else
    err=1
  fi
done

if [ $err -ne 0 ];then
  echo "error, application $OUR_APP is unknown"
  echo "Applications should be one of the: ${ALL_APPLICATIONS[@]}"
  exit 2
fi

function apiserver() {
  echo "=== Not implemented"
}
function asc() {
  echo "=== Not implemented"
}
function cdrcollectorsrc() {
  echo "=== Not implemented"
}
function cdrcollector() {
  echo "=== Not implemented"
}
function cdrprocessor() {
  echo "=== Not implemented"
}
function oracle() {
  echo "=== Not implemented"
}
function rtsserver() {
  echo "=== Not implemented"
}
function sipengine() {
  echo "=== Not implemented"
}
function sipmanagement() {
  echo "=== Not implemented"
}
function udrserver() {
  echo "=== Not implemented"
}

function coco() {
  echo "coco"
}
$OUR_APP
