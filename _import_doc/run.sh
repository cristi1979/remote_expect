#!/bin/bash

#/etc/my.cnf:
#max_allowed_packet = 10M

#chown apache:nobody -R /var/www/html/wiki/images/
#find /var/www/html/wiki/images/ -type d -exec chmod 775 {} \+

BASEDIR=$(cd $(dirname "$0"); pwd)
MY_DIR=$BASEDIR

IC_PATH="/media/share/Documentation/cfalcas/q/import_docs/instantclient_11_2"
ORA_USER="scview"
ORA_PASS="scview"
COL_SEP=';'
SQL_FILE="$MY_DIR/select_active_versions.sql"
SQL_OUTPUT_FILE="$MY_DIR/select_active_versions.out"
export LD_LIBRARY_PATH=$IC_PATH
export TWO_TASK=//10.0.0.103:1521/SCROM

SVN_URL_PROJ="http://10.10.4.4:8080/svn/repos/trunk/Projects/iPhonEX"
SVN_URL_DOCS="http://10.10.4.4:8080/svn/docs/repos/trunk/Documentation/iPhonEX%20Documents/iPhonEX/"
SVN_USER="svncheckout"
SVN_PASS="svncheckout"
SVN_INFO_FILE="wiki_helper_svn_trunk_info.txt"
SVN_LOCAL_BASE_PATH="$MY_DIR/svn_docs"

WIKI_PATH="/var/www/html/wiki/"
WIKI_USER="wiki_auto_import"
WIKI_UPLOADED_FILES="wiki_uploaded_files_info.txt"


OUTPUT_INFO_PREFIX="output_"
TIME_INFO_PREFIX="time_"
APPEND_DIR_ARRAY=( "Documents" "Scripts" )
MAX_IMG_SIZE=800

mkdir -p $SVN_LOCAL_BASE_PATH

function svn_update() {
    mkdir -p "$SVN_PATH"
    echo "url used: $use_url" >> "$SVN_PATH/$SVN_INFO_FILE"
    echo "local path used: $SVN_PATH" >> "$SVN_PATH/$SVN_INFO_FILE"
    echo "$main $COL_SEP $ver $COL_SEP $svn_url" | tr -s " " >> "$SVN_PATH/$SVN_INFO_FILE"
    echo svn co --non-interactive --no-auth-cache --trust-server-cert --password "$SVN_USER" --username "$SVN_PASS" "$use_url" "$SVN_PATH" >> "$SVN_PATH/$SVN_INFO_FILE"
    svn co --non-interactive --no-auth-cache --trust-server-cert --password "$SVN_USER" --username "$SVN_PASS" "$use_url" "$SVN_PATH"
}

function svn_from_query() {
    $IC_PATH/sqlplus -S $ORA_USER/$ORA_PASS @$SQL_FILE $COL_SEP $SQL_OUTPUT_FILE$SVN_EXTRA_PATH $SVN_URL

    if [ $? -ne 0 ]; then
	echo "query failed"
	exit 1
    fi
    while IFS=$COL_SEP read main ver svn_url; do
	for i in ${!APPEND_DIR_ARRAY[@]}; do
	    use_url="$svn_url/${APPEND_DIR_ARRAY[i]}"
	    SVN_PATH="$(echo $SVN_LOCAL_BASE_PATH/$SVN_EXTRA_PATH/$ver | tr -s " " | sed 's/[ \t]$//g')/${APPEND_DIR_ARRAY[i]}"
	    svn_update
	done
    done <$SQL_OUTPUT_FILE$SVN_EXTRA_PATH
}

function update_from_svn() {
    ### projects
    SVN_EXTRA_PATH="_proj"
    SVN_URL=$SVN_URL_PROJ
    svn_from_query

    use_url="$SVN_URL_PROJ/Common/Documents/"
    SVN_PATH="$SVN_LOCAL_BASE_PATH/$SVN_EXTRA_PATH/Common/Documents/"
    svn_update

    use_url="$SVN_URL_PROJ/Deployment/"
    SVN_PATH="$SVN_LOCAL_BASE_PATH/$SVN_EXTRA_PATH/Deployment"
    svn_update
    ### docs
    SVN_EXTRA_PATH="_docs"
    SVN_URL=$SVN_URL_DOCS
    svn_from_query

    use_url="$SVN_URL_DOCS/Customizations/"
    SVN_PATH="$SVN_LOCAL_BASE_PATH/$SVN_EXTRA_PATH/Customizations/"
    svn_update

    use_url="http://10.10.4.4:8080/svn/scdocs/repos/svnDocs/Documents/iPhonEX/"
    SVN_PATH="$SVN_LOCAL_BASE_PATH/scdocs/repos/svnDocs/Documents/iPhonEX/"
    svn_update
}

function image_work() {
	newfile=$(echo ${name%_*} | sed s/_html$/_/ | sed s/\ /_/g)$nr.$ext
	line_nr=$(grep -na "html_$strange_string.$ext" "$DIR_NAME/$HTML_FILE_NAME" | cut -d : -f 1);

	newfile=$(svn co "http://localhost/$file" 2>&1 | cut -d " " -f 4 | sed s/\':$//)
	newfile=${newfile##*/};
	line_nr=$(grep -na "<IMG SRC=\"$newfile\"" "$DIR_NAME/$HTML_FILE_NAME" | cut -d : -f 1);
	wiki_file_name=$(echo $file_name | sed s/\ /_/g)
	if [[ $line_nr -gt 0 ]]; then 
	    IMG_PROP=$(identify -verbose "$file" | grep "Geometry" | sed s/Geometry:// | sed 's/ *//' | cut -d + -f 1)
	    if [[ $IMG_PROP ]]; then 
		echo -n "." >&2
		W=${IMG_PROP##*x};
		L=${IMG_PROP%x*};
		MAX=$(echo -e "$L\n$W" | sort | head -1)
		if [[ $MAX -gt $MAX_IMG_SIZE ]];then 
		    PROC=$(echo "scale=2; $MAX_IMG_SIZE/$MAX" | bc -l )
		    printf "%s %s\000" "$line_nr $wiki_file_name|800px"
		else
		    printf "%s %s\000" "$line_nr $wiki_file_name"
		fi
	    else
		echo  -e "\nfile $file_name does not appear to be an image\n" >&2
	    fi
	else
	    echo -e "\nfile image $file_name was not found in $HTML_FILE_NAME\n" >&2
	fi
	echo "File:$wiki_file_name" >> $DIR_NAME/$WIKI_UPLOADED_FILES
}

function update_images_in_wiki_file() {
    WIKI_IMG_TAG="\[\[Image:\]\]"
    unset sorted_pictures;
    for i in ${!pics[@]}; do
	file=${pics[i]}
	file_name=${file##*/};
	ext=${file_name##*.};
	name=${file_name%.*};
	strange_string=${name##*_};

	time (image_work) 2>> "$TIME_INFO_PREFIX$NAME"
    done | sort -nz | xargs -0 -r -L 1 -I '{}' printf "%s\n" "{}" | cut -d " " -f 2- | \
	xargs -r -L 1 -I '{}' sed -i '-e/'$WIKI_IMG_TAG'/{;s/'$WIKI_IMG_TAG'/\[\[Image:'{}'|center\]\]/;:a' '-en;ba' '-e}'  "$DIR_NAME/$WIKI_FILE_NAME"
    echo "" >&2
    echo "File:$FILE_NAME" >> "$DIR_NAME/$WIKI_UPLOADED_FILES"

    echo "importing images" &>> "$TIME_INFO_PREFIX$NAME"
    time (php "$WIKI_PATH/maintenance/importImages.php" --conf "$WIKI_PATH/LocalSettings.php" --user="$WIKI_USER" --overwrite --check-userblock "$DIR_NAME" &>> "$OUTPUT_INFO_PREFIX$NAME") &>> "$TIME_INFO_PREFIX$NAME"
}

function file_was_modified() {
    echo $FILE
}

#time update_from_svn
## ~65 minutes first time
## ~9 minutes next checkout

while IFS= read -r -d $'\0' doc_file; do
    FILE="$doc_file";
    FILE_NAME=$(basename "$FILE")
    DIR_NAME=$(dirname "$FILE")
    DIR_NAME=$(cd "${DIR_NAME}";pwd)
    EXT=${FILE_NAME##*.};
    NAME=${FILE_NAME%.*};
    rm "$OUTPUT_INFO_PREFIX$NAME"
    rm "$TIME_INFO_PREFIX$NAME"

    echo "Delete previous files from wiki" &>> "$TIME_INFO_PREFIX$NAME"
    time (php $WIKI_PATH/maintenance/deleteBatch.php --conf $WIKI_PATH/LocalSettings.php "$DIR_NAME/$WIKI_UPLOADED_FILES" &>> "$OUTPUT_INFO_PREFIX$NAME") &>> "$TIME_INFO_PREFIX$NAME"
    echo "" > "$DIR_NAME/$WIKI_UPLOADED_FILES"

    WIKI_FILE_NAME="$NAME.wiki1"
    HTML_FILE_NAME="$NAME.html"
    echo "exporting $FILE_NAME to wiki and html" &>> "$TIME_INFO_PREFIX$NAME"
    time (/usr/bin/ooffice "$FILE" -headless -invisible "macro:///Standard.Module1.runall()" &>> "$OUTPUT_INFO_PREFIX$NAME") &>> "$TIME_INFO_PREFIX$NAME"

    #WIKI_FILE_NAME2="$NAME.wiki2"
    #echo "exporting with perl $HTML_FILE_NAME to wiki"
    #html2wiki --dialect MediaWiki "$DIR_NAME/$HTML_FILE_NAME" > "$DIR_NAME/$WIKI_FILE_NAME2"
    #echo $WIKI_FILE_NAME2
    #WIKI_PAGE_TITLE="$NAME"2
    #echo "$WIKI_PAGE_TITLE" >> "$DIR_NAME/$WIKI_UPLOADED_FILES"
    #php "$WIKI_PATH/maintenance/importTextFile.php" --user="$WIKI_USER" --title "$WIKI_PAGE_TITLE" "$DIR_NAME/$WIKI_FILE_NAME2"

    echo "done exporting $FILE" &>> "$OUTPUT_INFO_PREFIX$NAME"

    echo $WIKI_FILE_NAME 
    echo $HTML_FILE_NAME

    unset pics i;
    while IFS= read -r -d $'\0' pic_file; do
	pics[i++]="$pic_file";
    done < <(find $DIR_NAME -type f \( -iname "$NAME"\*.gif -o -iname "$NAME"\*.png -o -iname "$NAME"\*.jpg -o -iname \*.jpeg \) -print0)

    echo "update images in wiki" &>> "$TIME_INFO_PREFIX$NAME"
    time (update_images_in_wiki_file &>> "$OUTPUT_INFO_PREFIX$NAME") &>> "$TIME_INFO_PREFIX$NAME"

    WIKI_PAGE_TITLE="$NAME"
    echo "$WIKI_PAGE_TITLE" >> "$DIR_NAME/$WIKI_UPLOADED_FILES"
    echo "Import text in wiki" &>> "$TIME_INFO_PREFIX$NAME"
    time (php "$WIKI_PATH/maintenance/importTextFile.php" --user="$WIKI_USER" --title "$WIKI_PAGE_TITLE" "$DIR_NAME/$WIKI_FILE_NAME" &>> "$OUTPUT_INFO_PREFIX$NAME") &>> "$TIME_INFO_PREFIX$NAME"
    
    echo "Done for $NAME" &>> "$OUTPUT_INFO_PREFIX$NAME"
done < <(find $SVN_LOCAL_BASE_PATH/../ -maxdepth 1 -type f -name \*.doc -print0)
