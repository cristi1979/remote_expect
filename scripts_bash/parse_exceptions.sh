#!/bin/sh
NR_ARGS=3
##input: work_dir customer ip app emails files
if [ $# -lt $NR_ARGS ];then
  echo "We need work_dir app files. We got: $@"
  exit 1
fi

HERE=$(cd $(dirname "$0"); pwd)
ALL_APPLICATIONS=( $(ls $HERE/../scripts_tcl/app_logs_paths/ | sed s/\.tcl\// | awk '{printf "%s ",$0} END {print ""}') )
declare -a FILES
OUR_APP=""
WORK_DIR="/tmp"
POS=0
err=1
FUNCTION_SCRIPTS="$HERE/exceptions_parsers/"
regdate='(19|20[[:digit:]]{2})([- /.])(0[1-9]|1[012])([- /.])(0[1-9]|[12][0-9]|3[01])'
regtime='((0[0-9]|1[[:digit:]]|2[0123]):([0-5][[:digit:]]):([0-5][[:digit:]]),([[:digit:]]{3}))'

for var in ${@}; do
  let POS=$POS+1
  if [ $POS = 1 ]; then
    WORKDIR=$var;
  elif [ $POS = 2 ]; then
    OUR_APP=$var;
  else
    FILES=( "${FILES[@]}" "$var" )
    dos2unix -q $var
  fi
done

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

echo "Start script $SCRIPT_NAME"

CRT=$WORKDIR/$OUR_APP\_current
PRV=$WORKDIR/$OUR_APP\_previous
DIFF=$WORKDIR/$OUR_APP\_exceptions.txt
RESULT=$WORKDIR/attachements/$OUR_APP\_exceptions_$(date +%Y-%m-%d_%H.%M.%S).zip
mkdir -p "$WORKDIR/attachements"
if [ -f $CRT -a -s $CRT ];then
  echo "Previous file found: $CRT. Moving to $PRV."
  mv $CRT $PRV
  $OUR_APP > $CRT
  diff $PRV $CRT | grep "^>"| sed s/^\>\ // > $DIFF
else
  echo "No previous file found."
  $OUR_APP > $CRT
  cp $CRT $DIFF
fi

if [ -f $DIFF -a -s $DIFF ];then
  echo "Archiving result."
  unix2dos -q $DIFF
  zip -9 -j $RESULT $DIFF
  exit $?
fi
