#!/bin/bash

BASEDIR=$(cd $(dirname "$0"); pwd)
CUSTOMERS_PATH="$BASEDIR/customers/"
MACHINES_DIR="ips"
HEADER_NAME="header.tcl"
#TMP_DIR="/tmp/mind_remote/"
TMP_DIR="/media/share/remote/auto_scripts"

mkdir -p $TMP_DIR

function create_script {
  echo "#!/bin/expect"
  echo "source \"$mydirs/$HEADER_NAME\""
  echo "source \"\$crt_dir/ips/$filename\""
  echo "set ::get_period $INT"
  echo "catch {set ret [$1 $2]} res"
  echo "if {![string is integer -strict \$res]} { puts \"\n\tERR: \$res\"; set ret 1 }"
  echo "puts \$ret"
  echo "set nr_errors_file \"\$crt_dir/ips/$filename.errnr\""
  echo "if { (\$ret == \$::OK) || "
#: Tar failed on remote
  echo "  (\$ret == \$::ERR_ZERO_SIZE) || "
#: pid already running
  echo "  (\$ret == \$::ERR_ALREADY_RUNNING) || "
#: Could not send user/pass
  echo "  (\$ret == \$::ERR_CANT_CONNECT) || "
#: update period has not arrived yet
  echo "  (\$ret == \$::ERR_NOT_YET) || "
#: no basic ERR_APP_ERROR, ERR_SQLPLUS_ERR , ERR_TAR_ERROR
  echo "  (\$ret == \$::ERR_APP_ERROR) || "
  echo "  (\$ret == \$::ERR_SQLPLUS_ERR) || "
  echo "  (\$ret == \$::ERR_TAR_ERROR) || "
#: Machine is disabled
  echo "  (\$ret == \$::ERR_DISABLED) } {"
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
