#!/bin/bash

BASEDIR=$(cd $(dirname "$0"); pwd)
CUSTOMERS_PATH="$BASEDIR/customers/"
MACHINES_DIR="ips"
HEADER_NAME="header.tcl"
TMP_DIR="/tmp/mind_remote/"

mkdir -p $TMP_DIR

function create_script {
  echo "#!/bin/expect"
  echo "source \"$mydirs/$HEADER_NAME\""
  echo "source \"\$crt_dir/ips/$filename\""
  echo "set ::get_period $INT"
  echo "set ret [$1 $2]"
  echo "puts \$ret"
  echo "set nr_errors_file \"\$crt_dir/ips/$filename.errnr\""
  echo "if { (\$ret == 0) || "
# 5: Tar failed on remote
  echo "  (\$ret == 5) || "
#10: pid already running
  echo "  (\$ret == 10) || "
#20: Could not send user/pass
  echo "  (\$ret == 20) || "
#30: update period has not arrived yet
  echo "  (\$ret == 30) || "
#40: Wrong username or password.
#50: Machine is disabled
  echo "  (\$ret == 50) } {"
  echo "	puts \"ignore error \$ret\""
  echo "	file delete \"$OUTPUT_FILE\" \"$EXEC_FILE\" \"\$nr_errors_file\""
  echo "} else {"

  echo "   read_file \$nr_errors_file"
  echo "   if {![string is integer -strict \$::file_data]} {set ::file_data 0}"
  echo "	incr ::file_data"
  echo "	puts \"error \$ret is not good. Reached number \$::file_data\""
  echo "	write_file \$nr_errors_file"
  echo "	if {\$::file_data >= 5} {"
  echo "		puts \"set disable flag in \$crt_dir/ips/$filename\""
  echo "		set disable [open \"\$crt_dir/ips/$filename\" a]"
  echo "		puts \$disable {"
  echo "		set disabled \"\""
  echo "	}"
  echo "	close \$disable"
  echo "   }"
  echo "}"

  #echo "else {file rename \"$OUTPUT_FILE\" \"$EXEC_FILE\" \"$ERR_DIR\"}"
}

function run_scripts {
  TMP_FILE=$(mktemp --tmpdir=$TMP_DIR -u)
  tmpfilename=${TMP_FILE##*/}
  tmpext=${tmpfilename##*.}
  DATE=$(date +%s)
  OUTPUT_FILE=$TMP_DIR/$DATE\_$1\_$tmpext.output
  EXEC_FILE=$TMP_DIR/$DATE\_$1\_$tmpext.exec
  create_script $1 $2 > $EXEC_FILE
  chmod +x $EXEC_FILE
  nice -n 20 $EXEC_FILE &> $OUTPUT_FILE &
  sleep .2
  echo "$1 for $base"
}

for mydirs in $(find $CUSTOMERS_PATH -maxdepth 1 ! -path "$CUSTOMERS_PATH" -type d -print); do
  DIR="$mydirs/$MACHINES_DIR"
  if [ -d $DIR ]; then
    for myfiles in $(find $DIR -maxdepth 1 -mindepth 1 -name *.tcl -type f -print); do
      path=${myfiles%/*}
      filename=${myfiles##*/}
      base=${filename%.*}
      ext=${filename##*.}

      NRDAYS=1
      INT=240
      run_scripts get_apps_exceptions $NRDAYS
      INT=360
      run_scripts get_apps_statistics $NRDAYS
      run_scripts get_unix_statistics $NRDAYS
      INT=1450
      run_scripts exec_unix_statistics
      #run_scripts exec_tomcat_statistics
    done
  fi
done
