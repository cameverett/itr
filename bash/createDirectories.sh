#!/bin/bash

sourceRoot="/home"
group="instructors"
permissions="770"

showUsage()
{
	printf "Usage: classman create -s </path/to/studentfile>\n";
}

while getopts ":i:s:" opt; do
	case $opt in
		i )
			instructor="$OPTARG"
			INSTRUCTOR_HOME_DIR="/home/$OPTARG"
			;;
		s )
			studentfile="$OPTARG"
			;;
		* )
			showUsage
			exit 1
	esac
done

if [[ ! -d $INSTRUCTOR_HOME_DIR ]] || [[ ! -f $studentfile ]]; then
	showUsage
	exit 1
fi

mkdir -p "$INSTRUCTOR_HOME_DIR/{mynotes,returned,homework}"
chown "$instructor:$group" "$INSTRUCTOR_HOME_DIR/{mynotes,returned,homework}"
chmod "740" "$INSTRUCTOR_HOME_DIR/{mynotes,returned,homework}"

while read student; do
	STUDENT_HOME_DIR="$sourceRoot/$student"
	mkdir -p "$STUDENT_HOME_DIR/{submit,returned,mynotes}"
	chown -R "$student:$group" "$STUDENT_HOME_DIR/"
	mkdir -p "$INSTRUCTOR_HOME_DIR/returned/$student"

	if \
	[ -d "$STUDENT_HOME_DIR/submit" ] && \
	[ -d "$STUDENT_HOME_DIR/returned" ] && \
	[ -d "$STUDENT_HOME_DIR/mynotes" ];
	then
		printf "Directories created successfully for %s\n" "$student"
	else
		printf "Failed to create directories for %s\n" "$student"
	fi
done < $studentfile

chown -R "$instructor:$group" "$INSTRUCTOR_HOME_DIR/returned"
chmod -R 740 "$INSTRUCTOR_HOME_DIR/returned"
