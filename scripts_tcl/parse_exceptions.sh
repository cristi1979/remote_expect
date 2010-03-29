#!/bin/sh

if [ $# -lt 2 ];then
  echo We need the application name and at least one file
  exit 1
fi

declare -a ALL_FILES
ALL_FILES=$(ls -la "$@" 2>/dev/null | awk '{print $8}')

case $1 in
    apiserver )
        #echo ${2:+"$@"}  
      ;;
    asc )
        #echo ${2:+"$@"}  
      ;;
    cdrcollectorsrc )
        #echo ${2:+"$@"}  
      ;;
    cdrcollector )
        #echo ${2:+"$@"}  
      ;;
    cdrprocessor )
        #echo ${2:+"$@"}  
      ;;
    oracle )
        #echo ${2:+"$@"}  
      ;;
    rtsserver )
        #echo ${2:+"$@"}  
      ;;
    sipengine )
        #echo ${2:+"$@"}  
      ;;
    sipmanagement )
        #echo ${2:+"$@"}  
      ;;
    udrserver )
	for var in ${ALL_FILES[@]}; do
	    echo "		$var"
	done
      ;;
esac
