#!/bin/sh

##input: work_dir customer ip app emails files
if [ $# -lt 6 ];then
  echo "We need work_dir customer ip app emails files"
  exit 1
fi

HERE=$(cd $(dirname "$0"); pwd)
#ALL_APPLICATIONS=( apiserver asc cdrcollectorsrc cdrcollector cdrprocessor oracle rtsserver sipengine sipmanagement udrserver)
ALL_APPLICATIONS=( $(ls $HERE/../scripts_tcl/app_logs_paths/ | sed s/\.tcl\// | awk '{printf "%s ",$0} END {print ""}') )
declare -a FILES
OUR_APP=""
EMAILS=""
CUSTOMER=""
REMOTE_IP=""
WORK_DIR="/tmp"
POS=0
err=1
FUNCTION_SCRIPTS="$HERE/exceptions_parsers/"
regdate='(19|20[[:digit:]]{2})([- /.])(0[1-9]|1[012])([- /.])(0[1-9]|[12][0-9]|3[01])'
regtime='((0[0-9]|1[012]):([0-5][[:digit:]]):([0-5][[:digit:]]),([[:digit:]]{3}))'

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
    err=0
    break
  else
    err=1
  fi
done

if [ $err -ne 0 ];then
  echo "Error, application $OUR_APP is unknown"
  echo "Applications should be one of the: ${ALL_APPLICATIONS[@]}"
  exit 2
fi

SCRIPT_NAME=$FUNCTION_SCRIPTS/$OUR_APP.sh

## test function
#declare -f $OUR_APP > /dev/null
#if [[ $? -ne 0 ]];then 
if ! [ -f $SCRIPT_NAME -a -s $SCRIPT_NAME ];then
  echo "Function $OUR_APP does not exist. Creating template."
  echo "function $OUR_APP() {" 		>  $SCRIPT_NAME
  echo "  echo \"=== Not implemented\"" >> $SCRIPT_NAME
  echo '  cat $(ls -tr ${FILES[@]})'	>> $SCRIPT_NAME
  echo "} " 				>> $SCRIPT_NAME
  echo "" 				>> $SCRIPT_NAME
fi
. $SCRIPT_NAME

#TMP_DIR=$(mktemp --tmpdir=$WORKDIR -u)
CRT="$WORKDIR/current"
PRV="$WORKDIR/previous"
DIFF="$WORKDIR/new_difference"
mv $CRT $PRV
$OUR_APP > $CRT
diff $PRV $CRT | grep "^>"| sed s/^\>\ // > $DIFF

zip -9 $WORKDIR/new_exceptions.zip $DIFF
OUR_APP=""
CUSTOMER=""
REMOTE_IP=""
#echo Message | mailx -s _Subject_ -a $WORKDIR/new_exceptions.zip $EMAILS
