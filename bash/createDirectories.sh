#!/bin/bash

sourceRoot="/home"
group="instructors"
permissions="770"

showUsage()
{
	printf "Usage: bash -i <your username> createDirectories.sh -s </path/to/studentfile>\n";
}

while getopts ":i:c:s:" opt; do
	case $opt in
		i )
			INSTRUCTOR_HOME_DIR="/home/$OPTARG"
			;;
		s ) 
			studentfile=$OPTARG
			;;
		* )
			showUsage
			exit 1
	esac
done

if [ ! $INSTRUCTOR_HOME_DIR ] || [ ! -f $studentfile ]; then
			showUsage
			exit 1
fi

mkdir -p $INSTRUCTOR_HOME_DIR/{submissions,mynotes,returned}

while read student; do
	STUDENT_HOME_DIR="$sourceRoot/$student"
	mkdir -p $STUDENT_HOME_DIR/{submit,returned,mynotes}
	chown -R "$student:$group" $STUDENT_HOME_DIR/

	if \
	[ -d $STUDENT_HOME_DIR/submit ] && \
	[ -d $STUDENT_HOME_DIR/returned ] && \
	[ -d $STUDENT_HOME_DIR/mynotes ];
	then
		printf "Directories created successfully for $student\n"
	else
		printf "Failed to create directories for $student\n"
	fi
done < $studentfile

